class LocalCatalog < Catalog
  before_destroy :clean_up

  def import
    if self.sync_from_albums.blank?
      Resque.enqueue(LocalSynchronizer, "clone_instances_from_catalog", {:to_catalog_id => self.id, :from_catalog_id => self.sync_from_catalog})
    else
      self.sync_from_albums.each do |album_id|
        Resque.enqueue(LocalSynchronizer, "clone_instances_from_albums", {:catalog_id => self.id, :album_id => album_id})
      end
    end
  end


  def clone_instances_from_catalog(from_catalog_id=self.sync_from_catalog)
    Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
      new_instance = Instance.new
      new_instance.catalog_id = self.id
      new_instance.photo_id = instance.photo_id
      begin
        new_instance.save
      rescue ActiveRecord::RecordNotUnique
        logger.debug "instance exists"
      end
    end
  end

  def clone_instances_from_albums(from_album_id)
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

  def import_files(use_resque=true)
    photos.each do |photo|
      if use_resque
        Resque.enqueue(LocalSynchronizer, "import_files", {:photo_id => photo.id, :catalog_id => self.id})
      else
        copy_file(photo.id)
      end
    end
  end

  def copy_file(photo_id)
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
  private


end
