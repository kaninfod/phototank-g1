class DropboxSynchronizer
  @queue = :dropbox

  def self.perform(photo_id)
  
    begin
    
      @dropbox_client = login
      photo = Photo.find(photo_id)
      dst = File.join('/', 'rails', photo.path, photo.filename + photo.file_extension)
      src = photo.absolutepath
      copy_to_dropbox(src, dst) unless exist(dst)
    
    rescue Exception => e 
  
      raise "An error while synchonizing to Dropbox: #{e}"
    end
  end
  
  private
  
  def self.copy_to_dropbox(src, dst)
    begin
      response = @dropbox_client.put_file(dst, open(src))
    rescue Exception => e
      
    end
    
  end
  
  def self.exist(dst)
    begin
      response = @dropbox_client.metadata(dst, include_deleted=false)        
    rescue DropboxError
      puts response
      return false
    else
      puts response
      
        
      #TODO check for filesize
      return true
    end
  end
      
  
  def self.login
    
    access_token = 'UFefx_vmXWwAAAAAAAKYUjujc9-a8rdTeQHz_2vfgewJqvaHCByQ9Xe3_fM2T7Tm'
    client = DropboxClient.new(access_token)
    return client
  end
end