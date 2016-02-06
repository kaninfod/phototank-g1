class LocalCatalog < Catalog
  
  def sync
    photos.each do |photo|
       Resque.enqueue(LocalSynchronizer, photo.id, self.id) 
    end
  end  
  
  def online
    false
  end
  
  
  
end