class Photo < ActiveRecord::Base
  
  
  attr_accessor :medium_filename, :original_filename, :small_filename, :large_filename, :default_instance
  
  belongs_to :location
  has_many :instances
  has_many :catalogs, through: :instances 


  before_save :geocode

  reverse_geocoded_by :latitude, :longitude

  scope :year, ->(year) {
    where(date_taken: Date.new(year, 1, 1)..Date.new(year, 12, 31))
  }

  scope :country, ->(country) {
    joins(:location).where('locations.country = ?', country)
  }

  def query
    self.latitude.to_s + "," + self.longitude.to_s
  end  


  def original_filename
    @original_filename = File.join(self.path, self.filename  + self.file_extension)
    @original_filename
  end
    
  def small_filename
    @small_filename = File.join(self.file_thumb_path,self.filename + "_tm" + self.file_extension)
    @small_filename
  end
  
  def medium_filename
    @medium_filename = File.join(self.file_thumb_path,self.filename + "_md" + self.file_extension)
    @medium_filename
  end
  
  def large_filename
    @large_filename = File.join(self.file_thumb_path,self.filename + "_lg" + self.file_extension)
    @large_filename
  end
  
  def default_instance
    @default = Catalog.where(default: true).first  #"/Volumes/phototank/"
    @default.path
  end
  
  private
  
    def geocode
      if not self.latitude.blank? || self.longitude.blank?
        similar_locations = self.nearbys(1).where.not(location: nil)
        if similar_locations.blank?
          geo_location = Geocoder.search(self.query).first
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
            new_location.save
            self.location = new_location
          else
            self.location = nil  
          end
        else
          self.location = similar_locations.first.location
        end
      end    
    end 
end