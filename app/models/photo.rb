class Photo < ActiveRecord::Base
  
  belongs_to :location
  has_many :instances, dependent: :destroy 
  has_many :catalogs, through: :instances 
  reverse_geocoded_by :latitude, :longitude


  
  scope :year, ->(year) {
    where(date_taken: Date.new(year, 1, 1)..Date.new(year, 12, 31))
  }

  scope :country, ->(country) {
    joins(:location).where('locations.country = ?', country)
  }
  
  def self.album(alb)
    
    if not alb.start.blank?
      p_start = get_predicate('date_taken', alb.start, :gt) 
      exp = p_start
    end
    
    if not alb.end.blank? 
      p_end = get_predicate('date_taken', alb.end, :lt) 
      if not exp.blank?
        exp = exp&p_end
      else
        exp= p_end
      end
    end
    
    if not alb.make.blank?
      p_make = get_predicate('make', alb.make, :eq) 
      if not exp.blank?
        exp = exp&p_make
      else
        exp = p_make
      end
    end
    
    if not alb.model.blank?
      p_model = get_predicate('model', alb.model, :eq) 
      if not exp.blank?
        exp = exp&p_model
      else
        exp = p_model
      end
    end

    location_stub = Squeel::Nodes::Stub.new(:location)

    if not alb.country.blank?
      p_country = get_predicate(:country, alb.country, :eq) 
      k_country = Squeel::Nodes::KeyPath.new([location_stub, p_country])
      if not exp.blank?
        exp = exp&k_country
      else
        exp = k_country
      end
    end



    if not alb.city.blank?
      p_city = get_predicate('city', alb.city, :eq) 
      k_city = Squeel::Nodes::KeyPath.new([location_stub, p_city])
      if not exp.blank?
        exp = exp&k_city
      else
        exp = k_city
      end
    end
    
    
    if not alb.photo_ids.blank?
      p_photo_ids = get_predicate('id', alb.photo_ids, :in) 
      if not exp.blank?
        exp = exp|p_photo_ids
      else
        exp = p_photo_ids
      end
    end
    
    self.joins(:location).where(exp)
    
  end

  
  def coordinate_string
    self.latitude.to_s + "," + self.longitude.to_s
  end

  def original_filename
    @original_filename = File.join(self.path, self.filename + self.file_extension)
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
    @large_filename = File.join(self.file_thumb_path, self.filename + "_lg" + self.file_extension)
    @large_filename
  end
  
  def default_instance
    @default = Catalog.where(default: true).first  #"/Volumes/phototank/"
    @default.path
  end
  
  def populate_from_file path
    begin
      process_image path
      get_exif path
      process_thumbs path

      
    rescue Exception => e 
      logger.debug e
      return false
    end
    self
  end  

  def self.get_predicate(col, value, predicate)
    Squeel::Nodes::Predicate.new(Squeel::Nodes::Stub.new(col), predicate, value)
  end  
  
  private


  
end