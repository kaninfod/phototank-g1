class MasterCatalog < Catalog
  
  def sync
    photos.each do |photo|
       Resque.enqueue(LocalSynchronizer, photo.id, self.id) 
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