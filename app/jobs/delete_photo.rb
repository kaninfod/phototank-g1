class DeletePhoto
  @queue = :delete

  def self.perform(photo_id)

    begin 
      photo = Photo.find(photo_id)
      photo.instances.each do |instance|
        instance.catalog.delete_photo(photo_id)
      end
      
      
      
    rescue Exception => e 
      raise "An error occured while setting up the Importer: #{e}"
    end
        
  end
end
