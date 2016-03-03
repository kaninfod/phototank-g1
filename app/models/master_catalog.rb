
class MasterCatalog < Catalog
include ImportPhotoHelper



  def import
    raise "Catalog is not online" unless online
    begin
      self.watch_path.each do |import_path|
        if File.exist?(import_path)
          Resque.enqueue(MasterSpawnImportJob, import_path)
        else
          logger.debug "path #{import_path} did not exist"
        end
      end
      return true
    rescue Exception => e
      raise e
    end
  end

  def online
    File.exist?(self.path)
  end

  def delete_photo(photo_id)

    begin
      FileUtils.rm((self.photos.find(photo_id).original_filename))
      FileUtils.rm((self.photos.find(photo_id).large_filename))
      FileUtils.rm((self.photos.find(photo_id).medium_filename))
      FileUtils.rm((self.photos.find(photo_id).small_filename))
      self.instances.where(photo_id: photo_id).each{ |instance| instance.destroy}
      Photo.find(photo_id).destroy
    rescue Exception => e
      logger.debug "#{e}"
    end
  end

  def import_photo(import_path)
    Rails.logger.debug("enter model.import_photo")
    @photo = Photo.new
    @photo.import_path = import_path

    set_exif
    Rails.logger.debug("after setexif")
    process
    Rails.logger.debug("after process")
    @photo.save
    return @photo.id
  end

  private


end
