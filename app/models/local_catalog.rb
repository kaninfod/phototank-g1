class LocalCatalog < Catalog
  before_destroy :clean_up

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

  def sync_files
    photos.each do |photo|
       Resque.enqueue(LocalSynchronizer, photo.id, self.id)
    end
  end

  def import_from_catalog(from_catalog_id)
    Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
      new_instance = instance.dup
      new_instance.catalog_id = self.id
      begin
        new_instance.save
      rescue ActiveRecord::RecordNotUnique
        logger.debug "instance exists"
      end
    end
  end

  def import_from_album(from_album_id)
    from_album = Album.find(from_album_id)

    from_album.photos.each do |photo|
      new_instance = photo.instances.first.dup
      new_instance.catalog_id = self.id
      begin
        new_instance.save
      rescue ActiveRecord::RecordNotUnique
        logger.debug "instance exists"
      end
    end
  end



  def online
    true
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


end
