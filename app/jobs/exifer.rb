class Exifer
  @queue = :import

  def self.perform(path, catalog_id, photo_id, objid)
    #TODO add errorhandling if file not jpeg
    
    begin
    
      photo = Photo.unscoped.find(photo_id)
      photo_obj = JSON.parse($redis.get(objid))
      byebug
      instance = photo.instances.new
      instance.catalog_id = catalog_id
    
      exif = MiniExiftool.new(path, opts={:numerical=>true})
      if not exif.datetimeoriginal.blank?
        photo.date_taken = exif.datetimeoriginal 
      else
        photo.date_taken = File.ctime(path)
      end
      photo.longitude = exif.gpslongitude
      photo.latitude = exif.gpslatitude
      photo.make = exif.make
      photo.model = exif.model

      photo.save
      instance.save
    rescue Exception => e 
      raise "An error while setting up the Exifer job: #{e}"
    end
  end
end

