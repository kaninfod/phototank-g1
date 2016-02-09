class Locator
  include Resque::Plugins::UniqueJob
  @queue = :locate

  def self.perform(photo_id)
    
    begin
      
      @photo = Photo.find(photo_id)
      
      if no_coordinates
        return true
      elsif reuse_location
        return true
      elsif geosearch
        return true
      else
        @photo.location = get_no_location
        @photo.save
        return true
      end 
    
    rescue Exception => e 
      "An error occured while executing the Locator: #{e}"
    end
    
  end
  
  def self.no_coordinates()
    
    if @photo.latitude.blank? || @photo.longitude.blank?
      @photo.location = get_no_location
      @photo.save
      return true
    end
    
  end

  def self.reuse_location()
    
    similar_locations = @photo.nearbys(1).where.not(location_id: nil)
    if similar_locations.count(:all) > 0
      @photo.location = similar_locations.first.location
      @photo.save
      return true
    end
  end
  
  def self.geosearch
    if geo_location = Geocoder.search(@photo.coordinate_string).first
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
        @photo.location = new_location
        new_location.save
        @photo.save 
        return true
      end  
    end
  end
  
  def self.get_no_location
    
    no_loc = Location.where{(latitude.eq(0) & longitude.eq(0))}
    if no_loc.count > 0
      return no_loc.first
    else
      new_no_loc = Location.new
      new_no_loc.latitude = 0
      new_no_loc.longitude = 0    
      new_no_loc.save
      return new_no_loc
    end
  end
  
  
end