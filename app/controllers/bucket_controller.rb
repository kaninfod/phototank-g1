class BucketController < ApplicationController

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
  end

  def list
    @bucket = get_bucket
    @photos_in_bucket = Photo.where(id:@bucket)
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
