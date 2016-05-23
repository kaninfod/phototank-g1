class LocalCatalog < Catalog
  before_destroy :delete_contents

  def import
    #raise "Catalog is not online" unless online
    if self.sync_from_albums.blank?
      Resque.enqueue(LocalCloneInstancesFromCatalogJob, self.id, self.sync_from_catalog)
    else
      self.sync_from_albums.each do |album_id|
        Resque.enqueue(LocalCloneInstancesFromAlbumJob, self.id, album_id)
      end
    end
  end

  def import_photo(photo_id)
    photo = Photo.find(photo_id)
    src = photo.absolutepath
    dst = File.join(self.path, photo.path)
    if not File.exist?(photo.absolutepath(self.id))
      FileUtils.mkdir_p dst
      FileUtils.cp src, dst
    end
  end

  def online
    File.exist?(self.path)
  end

  def delete_contents
    #triggered when entire catalog is deleted
    photos.each do |photo|
      delete_photo photo.id
    end
  end

  def delete_photo(photo_id)

    begin
      #instance = self.instances.where{photo_id.eq(photo_id)}.first
      file_path = self.photos.find(photo_id).original_filename
      if not instance.nil?
        if File.exist?(file_path)
          FileUtils.rm(file_path)
        end
      end
      #instance.destroy
    rescue Exception => e

      logger.debug "#{e}"
    end
  end

  # def delete_photo(photo_id)
  #   begin
  #     FileUtils.rm((self.photos.find(photo_id).original_filename))
  #     FileUtils.rm((self.photos.find(photo_id).large_filename))
  #     FileUtils.rm((self.photos.find(photo_id).medium_filename))
  #     FileUtils.rm((self.photos.find(photo_id).small_filename))
  #     self.instances.where(photo_id: photo_id).each{ |instance| instance.destroy}
  #     Photo.find(photo_id).destroy
  #   rescue Exception => e
  #     logger.debug "#{e}"
  #   end
  # end
  private


end
