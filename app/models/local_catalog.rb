class LocalCatalog < Catalog
  before_destroy :clean_up

  def import
    raise "Catalog is not online" unless online
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

  def clean_up
    photos.each do |photo|
      if File.exist?(photo.absolutepath(self.id))
        FileUtils.rm(photo.absolutepath(self.id))
      end
    end

    Instance.where(catalog_id: self.id).each do |instance|
      instance.destroy
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
  private


end
