class Location < ActiveRecord::Base
  has_many :photos
  reverse_geocoded_by :latitude, :longitude

  scope :distinct_countries, -> {
    ary = select(:country).distinct.map { |c| [c.country] }.unshift([''])
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
  }
  scope :distinct_cities, -> {
    ary = select(:city).distinct.map { |c| [c.city] }.unshift([''])
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
  }

  def self.geolocate
    Photo.where{location_id.eq(nil)}.each do |photo|
      Resque.enqueue(Locator, photo.id)
    end
  end

  def self.locate_photo(photo)
    @photo = photo
    if no_coordinates
      return true
    elsif reuse_location
      return true
    elsif geosearch
      return true
    else

      @photo.location = get_no_location
      puts "no location returned"
      return true
    end

  end

  def get_map(zoom=10, size="350x300")
    marker = "#{self.latitude}%2C#{self.longitude}"
    return "http://maps.google.com/maps/api/staticmap?size=#{size}&sensor=false&zoom=#{zoom}&markers=#{marker}"
  end

  def self.no_location
    return get_no_location
  end


  private
  def self.no_coordinates()
    if @photo.latitude.blank? || @photo.longitude.blank?
      @photo.location = get_no_location
      return true
    end
  end

  def self.reuse_location()
    similar_locations = @photo.nearbys(1).where.not(location_id: nil)
    if similar_locations.count(:all) > 0
      @photo.location = similar_locations.first.location
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
