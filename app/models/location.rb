class Location < ActiveRecord::Base
  has_many :photos
  reverse_geocoded_by :latitude, :longitude

  def query
    self.latitude.to_s + "," + self.longitude.to_s
  end
  
  def self.geolocate
    Photo.where{location_id.eq(nil)}.each do |photo|
      Resque.enqueue(Locator, photo.id)
    end
  end
  

  
end
