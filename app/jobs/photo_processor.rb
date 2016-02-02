class PhotoProcessor
  @queue = :import

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '600x800'
  IMAGE_LARGE = '1024x1200'  


  def self.perform(photo_id, path, objid)
    
    @photo = Photo.unscoped.find(photo_id)
    photo_obj = JSON.parse($redis.get(objid))
    byebug
    
    begin
      @image = MiniMagick::Image.open(path)
      
      @photo.filename = @image.signature
      @photo.original_width = @image.width
      @photo.original_height = @image.height
      @photo.file_size = @image.size
      @photo.file_extension = ".jpg"

      date_path = File.join(@photo.date_taken.strftime("%Y"), @photo.date_taken.strftime("%m"), @photo.date_taken.strftime("%d"))
      sub_path = File.join(@photo.default_instance, 'phototank', 'thumbs', date_path).to_s
      FileUtils.mkdir_p sub_path
      
      
      resize_photo("_lg", IMAGE_LARGE, sub_path)
      resize_photo("_md", IMAGE_MEDIUM, sub_path)
      resize_photo("_tm", IMAGE_THUMB, sub_path)
      
      @photo.file_thumb_path = File.join('phototank', 'thumbs', date_path)
              
      sub_path = File.join(@photo.default_instance, 'phototank', 'originals', date_path).to_s
      file_path = File.join(sub_path, @photo.filename + @photo.file_extension).to_s
      FileUtils.mkdir_p sub_path
      File.rename path, file_path
      
      @photo.path = File.join('phototank', 'originals', date_path)
      @photo.status = 0
      @photo.save

      
    rescue Exception => e 
      raise "An error occured while executing the PhotoProcessor: #{e}" 

    end
  end  
  
  private
    
  def self.resize_photo(suffix, size, sub_path)
    file_path = File.join(sub_path, @photo.filename + suffix + @photo.file_extension).to_s
    if not File.exists?(file_path)
      @image.resize size
      @image.write file_path
    end
  end
    
  
end