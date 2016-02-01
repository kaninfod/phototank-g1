class Locator
  @queue = :import

  def self.perform(photo_id)
    photo = Photo.find(photo_id)
    if not photo.latitude.blank? || photo.longitude.blank?
      similar_locations = photo.nearbys(1).where.not(location: nil)
      if not similar_locations.blank?
        photo.location = similar_locations.first.location
      else
        geo_location = Geocoder.search(photo.coordinate_string).first
        
        if not geo_location.nil?
          if geo_location.data["error"].blank?
            new_location = Location.new
            new_location.country = geo_location.country
            new_location.city = geo_location.city
            new_location.suburb = geo_location.suburb
            new_location.postcode = geo_location.postal_code
            new_location.address = geo_location.address
            new_location.state = geo_location.state
            new_location.longitude = geo_location.longitude
            new_location.latitude = geo_location.latitude
            photo.location = new_location
          else
            photo.location = nil  #geo failed
          end
        else
          photo.location = nil  #nil from geo
        end
      end
    end    
  end
end