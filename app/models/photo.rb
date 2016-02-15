class Photo < ActiveRecord::Base

  belongs_to :location
  has_many :instances, dependent: :destroy
  has_many :catalogs, through: :instances
  reverse_geocoded_by :latitude, :longitude

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'

  attr_accessor :import_path

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

  def set_exif(path=false)

    raise "File does not exist" unless File.exist?(self.import_path)

    exif = MiniExiftool.new(self.import_path, opts={:numerical=>true})

    if not exif.datetimeoriginal.blank?
      self.date_taken = exif.datetimeoriginal
    else
      self.date_taken = File.ctime(self.import_path)
    end

    self.longitude = exif.gpslongitude
    self.latitude = exif.gpslatitude
    self.make = exif.make
    self.model = exif.model
    self
  end


  def process( clone_mode = 'copy')

    raise "File does not exist" unless File.exist?(self.import_path)

    @image = MiniMagick::Image.open(self.import_path)
    self.filename = @image.signature

    #Check if file already exists in system (db and file)

    existing_photo = Photo.where(filename: self.filename).where(date_taken: self.date_taken)
    if existing_photo.present?
      raise "Photo #{existing_photo.first.filename} already exists"
    end

    self.original_width = @image.width
    self.original_height = @image.height
    self.file_size = @image.size
    self.file_extension = ".jpg"

    #set relative paths
    date_path = File.join(self.date_taken.strftime("%Y"), self.date_taken.strftime("%m"), self.date_taken.strftime("%d"))
    self.file_thumb_path = File.join('phototank', 'thumbs', date_path)
    self.path = File.join('phototank', 'originals', date_path).to_s

    #Create absolute path for thumbs in master archive
    _absolute_path_thumbs = File.join(Catalog.master.path, 'phototank', 'thumbs', date_path)
    FileUtils.mkdir_p _absolute_path_thumbs
    #Create absolute path for originals in master archive
    _absolute_path_original = File.join(Catalog.master.path, 'phototank', 'originals', date_path)
    FileUtils.mkdir_p _absolute_path_original


    self.resize_photo("_lg", IMAGE_LARGE, _absolute_path_thumbs)
    self.resize_photo("_md", IMAGE_MEDIUM, _absolute_path_thumbs)
    self.create_thumbnail(_absolute_path_thumbs)


    if clone_mode == 'copy'
      FileUtils.cp self.import_path, File.join(_absolute_path_original, self.filename + self.file_extension)
    else
      File.rename self.import_path, File.join(_absolute_path_original, self.filename + self.file_extension)
    end

  end

  def locate
    Location.locate_photo(self)
  end

private

  def create_thumbnail(_absolute_path_thumbs)

    dst = File.join(_absolute_path_thumbs, self.filename + "_tm" + self.file_extension)
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", self.import_path]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << dst
    end
  end

  def resize_photo(suffix, size, _absolute_path_original)
    file_path = File.join(_absolute_path_original, self.filename + suffix + self.file_extension)
    if not File.exist?(file_path)
      @image.resize size
      @image.write file_path
    end
  end

end
