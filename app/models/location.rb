class Location < ActiveRecord::Base
  has_many :photos
  reverse_geocoded_by :latitude, :longitude


  def query
    self.latitude.to_s + "," + self.longitude.to_s
  end
end
