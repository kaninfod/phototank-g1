
class LocalSynchronizer
  @queue = :local_sync

  def self.perform(photo_id, catalog_id)
  
    begin
      
      photo = Photo.find(photo_id)
      src = photo.absolutepath
      dst = photo.absolutepath(catalog_id)
      copy_file(src, dst) unless File.exist?(dst)
      
    rescue Exception => e 
  
      raise "An error while synchonizing to Dropbox: #{e}"
    end
  end
  
  def self.copy_file(src, dst)
    FileUtils.mkdir_p dst
    FileUtils.cp src, dst
  end
  
end
