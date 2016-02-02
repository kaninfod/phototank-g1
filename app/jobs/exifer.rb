class Exifer
  @queue = :import

  def self.perform(path, catalog_id, photo_id, objid)
    #TODO add errorhandling if file not jpeg
    
    begin
      catalog_path = Catalog.find(catalog)
      #photo = Photo.unscoped.find(photo_id)
      photo_obj = JSON.parse($redis.get(objid))
    
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
      $redis.set objid, photo_obj.to_json
      
      #photo.save
      #instance.save
    rescue Exception => e 
      raise "An error while setting up the Exifer job: #{e}"
    end
  end
end

