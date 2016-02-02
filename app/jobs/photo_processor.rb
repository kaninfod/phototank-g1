class PhotoProcessor
  @queue = :import

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '600x800'
  IMAGE_LARGE = '1024x1200'  


  def self.perform( path, objid, catalog, photo )
    
    begin
      byebug
      photo_obj = JSON.parse($redis.get(objid))
      
      photo_obj = get_exif(path, photo_obj)
      photo_obj = process_photo(path, catalog_path, photo_obj)
      
      $redis.set objid, photo_obj.to_json

      Photo.new(JSON.parse($redis.get(objid))).save
      

    rescue Exception => e 
      raise "An error occured while executing the PhotoProcessor: #{e}" 

    end
  end  
  
  private
    
  def self.resize_photo(suffix, size, sub_path, photo_obj)
    file_path = File.join(sub_path, photo_obj['filename'] + suffix + photo_obj['file_extension']).to_s
    if not File.exists?(file_path)
      @image.resize size
      @image.write file_path
    end
  end
    
  def self.process_photo(path, catalog_path, photo_obj)
    @image = MiniMagick::Image.open(path)
    photo_obj['filename'] = @image.signature
    photo_obj['original_width'] = @image.width
    photo_obj['original_height'] = @image.height
    photo_obj['file_size'] = @image.size
    photo_obj['file_extension'] = ".jpg"

    date_path = File.join(photo_obj['date_taken'].strftime("%Y"), photo_obj['date_taken'].strftime("%m"), photo_obj['date_taken'].strftime("%d"))
    sub_path = File.join(catalog_path, 'phototank', 'thumbs', date_path).to_s
    FileUtils.mkdir_p sub_path
    
    
    resize_photo("_lg", IMAGE_LARGE, sub_path, photo_obj)
    resize_photo("_md", IMAGE_MEDIUM, sub_path ,photo_obj)
    resize_photo("_tm", IMAGE_THUMB, sub_path, photo_obj)
    
    photo_obj['file_thumb_path'] = File.join('phototank', 'thumbs', date_path)
            
    sub_path = File.join(catalog_path, 'phototank', 'originals', date_path).to_s
    file_path = File.join(sub_path, photo_obj['filename'] + photo_obj['file_extension']).to_s
    FileUtils.mkdir_p sub_path
    File.rename path, file_path
    
    photo_obj['path'] = File.join('phototank', 'originals', date_path)
    
    return photo_obj    
  end
  
  def self.get_exif(path, photo_obj)
    
    exif = MiniExiftool.new(path, opts={:numerical=>true})
    if not exif.datetimeoriginal.blank?
      photo_obj['date_taken'] = exif.datetimeoriginal 
    else
      photo_obj['date_taken'] = File.ctime(path)
    end
    photo_obj['longitude'] = exif.gpslongitude
    photo_obj['latitude'] = exif.gpslatitude
    photo_obj['make'] = exif.make
    photo_obj['model'] = exif.model
    return photo_obj
    
  end
  
end