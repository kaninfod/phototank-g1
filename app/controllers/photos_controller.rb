class PhotosController < ApplicationController

  def image
    @photo = set_photo

    if params[:size] == "original"
      filepath = File.join(@photo.original_filename)
    elsif params[:size] == "large"
      filepath = File.join(@photo.large_filename)
    elsif params[:size] == "small"
      filepath = File.join(@photo.small_filename)
    else
      filepath = File.join(@photo.medium_filename)
    end

    if File.exist?(filepath)
      send_file filepath, :disposition => 'inline'
    else
      send_file Rails.root.join('app', 'assets', 'images', 'missing_tm.jpg'), :disposition => 'inline'
    end
  end

  def index
    viewmode
    prep_form
    
    #has the user set any search paramaters
    if params.has_key?(:album)
      @album = Album.new(album_params)
    else
      @album = Album.new
    end

    #Get photos
    @photos = @album.photos.order(:date_taken).paginate(:page => params[:page], :per_page => 16)

    #If this was requested from an ajax call it should be rendered with slim view
    if request.xhr?
      render :partial=>"photos/view/grid"
    end
  end

  def show
    if params.has_key?(:size)
      @size = params[:size]
    else
      @size = 'medium'
    end
    @photo = Photo.find(params[:id])
  end

  private
  def album_params
    params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids, :album_type)
  end

  def viewmode
    if params.has_key?(:viewmode)
      @view = params[:viewmode]
    else
      @view = 'grid'
    end
  end

  def prep_form
    @countries = Location.distinct_countries
    @cities = Location.distinct_cities
    @makes = Photo.distinct_makes
    @models = Photo.distinct_models
    @bucket = session[:bucket]
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:filename, :date_taken, :path, :file_thumb_path, :file_extension, :file_size, :location_id, :make, :model, :original_height, :original_width, :longitude, :latitude)
    end
end
