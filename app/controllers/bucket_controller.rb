class BucketController < ApplicationController
  before_action :authenticate_user!
  def add
    session[:bucket].push params[:id].to_i
    render :json => {'count' => session[:bucket].count}
  end

  def remove
    session[:bucket].delete(params[:id].to_i)
    render :json => {'count' => session[:bucket].count}
  end

  def clear
    session[:bucket] = []
    redirect_to bucket_path
  end

  def count
    render :json => {'count' => session[:bucket].count}
  end

  def index
    @bucket = get_bucket
    @photos = Photo.where(id:@bucket).page params[:page]
    #If this was requested from an ajax call it should be rendered with slim view
    if request.xhr?
      render :partial=>"photos/view/grid"
    end
  end

  def list
    @bucket = get_bucket
    @photos_in_bucket = Photo.where(id:@bucket).limit(28)
    render layout: false
  end

  def save_to_album
    @album = Album.new
    @album.name = "Saved from bucket"
    @album.photo_ids = session[:bucket]
    @bucket = session[:bucket]
    session[:bucket] = []
    if @album.save
      redirect_to edit_album_path @album
    end
  end

  def delete_photos
    session[:bucket].each do |photo_id|
      Resque.enqueue(DeletePhoto, photo_id)
    end
    session[:bucket] = []
    redirect_to bucket_path
  end

  def rotate
    if params.has_key? :degrees
      @bucket = get_bucket
      Photo.find(@bucket).each do |photo|
        photo.rotate(params[:degrees])
      end
      redirect_to session[:finalurl]
    else
      session[:finalurl] = request.referer
    end
  end


  def edit

    session[:finalurl] = request.referer
    @submit_path = "/bucket/update"
    @photo = Photo.new
  end

  def update
    @bucket = get_bucket
    Photo.find(@bucket).each do |photo|
      #update the database entry
      if photo.update(params.permit(:date_taken, :location_id))
        #update the exif data on the original photo
        Resque.enqueue(PhotoUpdateExif, photo.id)
      end
    end
    redirect_to session[:finalurl]
  end
  private


  def get_bucket
    if session.include? 'bucket'
      session[:bucket]
    else
      session[:bucket] = []
      session[:bucket]
    end
  end


end
