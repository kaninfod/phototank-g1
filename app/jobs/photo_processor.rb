class PhotoProcessor
  @queue = :import

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'  


  def self.perform( path, catalog, photo )
    
    begin
      
      photo = get_exif(path, photo)
      photo = process_photo(path, catalog['path'], photo)
      photo = Photo.new(photo)
      photo.save
      instance = photo.instances.new
      instance.catalog_id = catalog['id']
      instance.save

    rescue MiniMagick::Invalid
      Rails.logger.debug  "#{e}"
    rescue Exception => e 
      Rails.logger.debug  "#{e}"
      #raise "An error occured while executing the PhotoProcessor: #{e}" 
    end
  end  
  
  private
    
    
  def self.process_photo(path, catalog_path, photo_obj)
    @image = MiniMagick::Image.open(path)
    photo_obj['filename'] = @image.signature
    
    #Check if file already exists in system (db and file)
    if Photo.where{filename.eq(photo_obj['filename']) & date_taken.eq(photo_obj['date_taken'])}.present?
      p = Photo.where{filename.eq(photo_obj['filename']) & date_taken.eq(photo_obj['date_taken'])}.first
      if p.validate_files
        raise "Photo #{p.filename} already exists"
      end 
    end
    
    photo_obj['original_width'] = @image.width
    photo_obj['original_height'] = @image.height
    photo_obj['file_size'] = @image.size
    photo_obj['file_extension'] = ".jpg"

    date_path = File.join(photo_obj['date_taken'].strftime("%Y"), photo_obj['date_taken'].strftime("%m"), photo_obj['date_taken'].strftime("%d"))
    sub_path = File.join(catalog_path, 'phototank', 'thumbs', date_path).to_s
    FileUtils.mkdir_p sub_path
    
    
    resize_photo("_lg", IMAGE_LARGE, sub_path, photo_obj)
    resize_photo("_md", IMAGE_MEDIUM, sub_path ,photo_obj)

    create_thumbnail(path, sub_path, photo_obj)

    
    photo_obj['file_thumb_path'] = File.join('phototank', 'thumbs', date_path)
            
    sub_path = File.join(catalog_path, 'phototank', 'originals', date_path).to_s
    file_path = File.join(sub_path, photo_obj['filename'] + photo_obj['file_extension']).to_s
    FileUtils.mkdir_p sub_path
    FileUtils.cp path, file_path
    #File.rename path, file_path
    
    photo_obj['path'] = File.join('phototank', 'originals', date_path)
    
    return photo_obj    
  end


  def self.create_thumbnail(src, sub_path, photo_obj)

    dst = File.join(sub_path, photo_obj['filename'] + "_tm" + photo_obj['file_extension']).to_s
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", src]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << dst
    end
  end

  def self.resize_photo(suffix, size, sub_path, photo_obj)
    file_path = File.join(sub_path, photo_obj['filename'] + suffix + photo_obj['file_extension']).to_s
    if not File.exist?(file_path)
      @image.resize size
      @image.write file_path
    end
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

MiniMagick::Tool::Convert.new do |convert|
  convert.merge! ["-size", "200x200", "/Users/martinhinge/Downloads/pics/watch/1b492cc5a39286b04d8b76abdbf65c22435aacace36870b066e6d6a91df8658c.jpg"]
  convert.merge! ["-thumbnail", "125x125^"]
  convert.merge! ["-gravity", "center"]
  convert.merge! ["-extent", "125x125", "+profile", "'*'"]
  convert << "out.jpg"
end
MiniMagick::Tool::Convert.new('-size", "200x200", "/Users/martinhinge/Downloads/pics/watch/1b492cc5a39286b04d8b76abdbf65c22435aacace36870b066e6d6a91df8658c.jpg -thumbnail 125x125^ -gravity center -extent 125x125 +profile "*" out.jpg')

