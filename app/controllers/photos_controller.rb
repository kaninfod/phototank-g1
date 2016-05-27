
class PhotosController < ApplicationController
  before_action :authenticate_user!
  def image
    @photo = set_photo
    send_file @photo.get_photo(params[:size]), :disposition => 'inline'
  end

  def index
    album_hash = {}

    if params.has_key? :query
      query = Hash[params[:query].split("/").each_slice(2).to_a].symbolize_keys

      if query.has_key? :country
        album_hash[:country] = query[:country] unless query[:country] == "All"
      end

      if query.has_key? :direction
        case query[:direction]
        when "true"
          album_hash[:start] = set_date(query)
          @searchbox[:direction] = "true"
          order = "asc"
        when "false"
          album_hash[:end] = set_date(query)
          @searchbox[:direction] = "false"
          order = "desc"
        end
      else
        order = "desc"
        album_hash[:end] = set_date(query)
        @searchbox[:direction] = "false"
      end
    else
      order = "desc"
      album_hash[:end] = set_date(nil)
      @searchbox[:direction] = "false"
    end

    #get album from url params through set_query_data
    @album = Album.new(album_hash)
    #Get photos
    Rack::MiniProfiler.step("fetch projects") do
      @photos = @album.photos.order(date_taken: order).paginate(:page => params[:page], :per_page => 50)
    end
    #grid or table
    viewmode

    #get distinct data for dropdowns
    prep_form

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

    # url = URI(request.referer).path
    # url.slice!(0)
    #
    # qry = Hash[url.split("/").each_slice(2).to_a].symbolize_keys
    # qry[:year] = @photo.date_taken.year
    # qry[:month] = @photo.date_taken.month
    # qry[:day] = @photo.date_taken.day
    # @backurl = "q/year/#{qry[:year]}/month/#{qry[:month]}/day/#{qry[:day]}"
    #
    # if qry[:direction]
    #   @backurl = "#{@backurl }/direction/#{qry[:direction]}"
    # end
    #
    # if qry[:country]
    #   @backurl = "#{@backurl }/country/#{qry[:country]}"
    # end

  end


  def edit
    @photo = Photo.find(params[:id])
    session[:finalurl] = request.referer
    @submit_path = "/photos/#{params[:id]}"
  end

  def update
    photo = Photo.find(params[:id])
    if request.patch?
      if photo.update(params.permit(:date_taken, :location_id))
        Resque.enqueue(PhotoUpdateExif, photo.id)
        redirect_to session[:finalurl]
      end
    end
  end

  def rotate
    @photo = Photo.find(params[:id])
    if params.has_key? :degrees
      @photo.rotate(params[:degrees])
      redirect_to session[:finalurl]
    else
      session[:finalurl] = request.referer
    end
  end

  def destroy
    photo = Photo.find(params[:id])
    photo.delete

    if request.xhr?
      render json: {:notice=>'Photo has been queued for deletion'}
    else
      flash[:notice] = 'Photo has been queued for deletion'
      redirect_to request.referer
    end
  end


  private

  def set_date(query)

    start = {:year=>Date.today.year, :month=>01, :day=>01}
    if query != nil
      start[:year]=query[:year].to_i unless not query.has_key?(:year)
      start[:month]=query[:month].to_i unless not query.has_key?(:month)
      start[:day]=query[:day].to_i unless not query.has_key?(:day)
    end


    if query == nil
      @searchbox = {
          :type=>"all",
          :day => start[:day],
          :month => start[:month],
          :year => start[:year],
          :values => Photo.years}
    elsif query.has_key?(:day)
      @searchbox = {
          :type => "day",
          :day => start[:day],
          :month => start[:month],
          :year => start[:year],
          :values => Photo.days(start[:year], start[:month])}
    elsif query.has_key?(:month)
      @searchbox = {
          :type=>"month",
          :day => start[:day],
          :month => start[:month],
          :year => start[:year],
          :values => Photo.days(start[:year], start[:month])}
    elsif query.has_key?(:year)
      @searchbox = {
          :type=>"year",
          :day => start[:day],
          :month => start[:month],
          :year => start[:year],
          :values => Photo.months(start[:year])}
    else
      @searchbox = {
          :type=>"all",
          :day => start[:day],
          :month => start[:month],
          :year => start[:year],
          :values => Photo.years}
    end

    start = Date.new(start[:year], start[:month], start[:day])

  end

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
    @countries[0] = "All"
    #@cities = Location.distinct_cities
    #@makes = Photo.distinct_makes
    #@models = Photo.distinct_models
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
