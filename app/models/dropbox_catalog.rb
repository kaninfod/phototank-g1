class DropboxCatalog < Catalog
    
  def sync
    photos.each do |photo|
       Resque.enqueue(DropboxSynchronizer, photo.id) 
    end
  end    
  
  def online
    File.exist?(self.path)
  end
    
end