class BucketController < ApplicationController

  def add
    session[:bucket].push params[:id].to_i
    puts session[:bucket]
    render :json => {'count' => session[:bucket].count}
  end

  def remove
    get_bucket
    session[:bucket].delete(params[:id].to_i) 
    
    puts session[:bucket]
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
