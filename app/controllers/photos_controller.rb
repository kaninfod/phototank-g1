
class PhotosController < ApplicationController
  before_action :authenticate_user!
  include BucketActions


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

    @photos = @album.photos.order(date_taken: order).paginate(:page => params[:page], :per_page=>40)

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

    if request.xhr?
      render :layout => false
    end

  end


  def edit
    @photo = Photo.find(params[:id])
    session[:finalurl] = request.referer
    @submit_path = "/photos/#{params[:id]}"
  end

  def update
    if request.xhr?
      data = params[:_json].map{|a| {a["name"]=>a["value"]}}.reduce({}, :merge)
      data = data.reject { |k,v| v.empty? }
      data = data.delete_if { |k,v| k == "location_address" }
      photo = Photo.find(params[:id])
      if photo.update(data)
        Resque.enqueue(PhotoUpdateExif, photo.id)
      end
    end
    render json: {'ok'=>1}
  end

  def rotate
    @photo = Photo.find(params[:id])
    if params.has_key? :degrees
      @photo.rotate(params[:degrees])
      if params[:finalurl].nil?
        redirect_to "/photos"
      else
        redirect_to session[:finalurl]
      end
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

  def add_comment
    if params.has_key? "comment"
      comment = add_comment_photo(params[:id], params[:comment])
      render :partial => "photos/show/comment", :locals => {:comment => comment }
    end
  end

  def like
    photo = Photo.find(params[:id])
    if current_user.voted_for? photo
      photo.unliked_by current_user
    else
      photo.liked_by current_user
    end
    render :json => {:likes => photo.votes_for.size}
  end

  def addtag
    photo = Photo.find params[:id]

    if params[:tag][0,1] == "@"
      photo.objective_list.add params[:tag]
    else
      photo.tag_list.add params[:tag]
    end

    if photo.save
      render :json => {:tags => photo.tags}
    else
      render :status => "500"
    end
  end

  def removetag
    photo = Photo.find params[:id]

    if params[:tag][0,1] == "@"
      photo.objective_list.remove params[:tag]
    else
      photo.tag_list.remove params[:tag]
    end

    if photo.save
      render :json => {:tags => photo.tags}
    else
      render :status => "500"
    end
  end

  def get_tag_list
    query_string = params[:term]
    taglist = ActsAsTaggableOn::Tag.most_used.where("name like ?", "#{query_string}%")
    autocomplete_list = taglist.map do |e|
      {:id=> e.id, :value=>e.name}
    end
    render :json => autocomplete_list
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
