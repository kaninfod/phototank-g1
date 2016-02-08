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
  

  def validate_files(catalog_id=1)
    catalog_path = self.catalog(catalog_id).path
    
    org = File.exist?(original_filename)
    sm = File.exist?(small_filename)
    md = File.exist?(medium_filename)
    lg = File.exist?(large_filename)

    return org & lg & md & sm   
  end
  
  def delete_from_catalog(catalog_id)
    
    File.delete(self.absolutepath(catalog_id))
    File.delete(self.absolutepath(catalog_id))
    File.delete(self.absolutepath(catalog_id))
    File.delete(self.absolutepath(catalog_id))
  end
  
  
  def coordinate_string
    self.latitude.to_s + "," + self.longitude.to_s
  end

  def absolutepath(catalog_id=Catalog.master.id)
    File.join(self.catalog(catalog_id).path, self.path, self.filename + self.file_extension)    
  end

  def original_filename(catalog_id=Catalog.master.id)
    absolutepath(catalog_id)
  end
    
  def small_filename(catalog_id=Catalog.master.id)
    small_filename = File.join(self.catalog(catalog_id).path, self.file_thumb_path,self.filename + "_tm" + self.file_extension)
    small_filename
  end
  
  def medium_filename(catalog_id=Catalog.master.id)
    medium_filename = File.join(self.catalog(catalog_id).path, self.file_thumb_path,self.filename + "_md" + self.file_extension)
    medium_filename
  end
  
  def large_filename(catalog_id=Catalog.master.id)
    large_filename = File.join(self.catalog(catalog_id).path, self.file_thumb_path, self.filename + "_lg" + self.file_extension)
    large_filename
  end
  
  def catalog(catalog_id=Catalog.master.id)
    self.catalogs.where{id.eq(catalog_id)}.first
  end
  
  def default_instance
    default = Catalog.where(default: true).first  #"/Volumes/phototank/"
    default.path
  end
  

  
end