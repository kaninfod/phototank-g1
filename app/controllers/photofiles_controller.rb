require 'filemagic'
class PhotofilesController < ApplicationController

  PATH = Rails.configuration.x.phototank["filestorepath"]
  ALLOWED_MIMES = ["image/jpeg; charset=binary"]

  def index
    @photos = Photofile.all
  end

  def create
    byebug
    @photo=file_handler(params[:data])
  end

  def show
    begin
      @photo = Photofile.find(params[:id])
      @photo.url = url_for(action: 'photoserve', controller: 'photofiles', only_path: false, protocol: 'http')
    rescue ActiveRecord::RecordNotFound
      render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
    end
  end

  def update
    begin
      photo = Photofile.find(params[:id])
      @photo=file_handler(params[:data], photo)
    rescue ActiveRecord::RecordNotFound
      render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
    end

  end

  def destroy
    begin
      @photo = Photofile.find(params[:id])
      FileUtils.rm @photo.path if File.exists? @photo.path
      @photo.destroy
      render status: 202
    rescue ActiveRecord::RecordNotFound
      render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
    end
  end

  def photoserve
    begin
      @photo = Photofile.find(params[:id])
      send_file @photo.path, type: 'image/jpeg', :disposition => 'inline'
    rescue ActiveRecord::RecordNotFound
      render status:404, json: {:msg=>"photo with #{params[:id]} does not exist"}
    end
  end

  private

  def file_handler(string, photo=nil)

    decoded_file = Base64.decode64(string)
    file = Tempfile.new("temp.tmp")
    begin
      file.binmode
      file.write decoded_file
      mime = FileMagic.new(FileMagic::MAGIC_MIME).file(file.path)

      if ALLOWED_MIMES.include? mime
        if photo.nil?
          filename = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(13).next.join
          filepath = File.join(PATH, filename)
          photo = Photofile.create(path: filepath)
        else
          #photo = Photo.find(photo_id)
          filepath = photo.path
          FileUtils.rm filepath
          photo.touch
        end
        FileUtils.cp file.path, filepath
        photo.url = url_for(action: 'photoserve', controller: 'photofiles', only_path: false, protocol: 'http', id: photo.id)
        return photo
      end

    ensure
      file.close
      file.unlink
    end

  end


end
