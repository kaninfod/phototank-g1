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

  scope :distinct_models, -> {
    ary = select(:model).distinct.map { |c| [c.model] }.unshift([''])
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
  }

  scope :distinct_makes, -> {
    ary = select(:make).distinct.map { |c| [c.make] }.unshift([''])
    ary.delete([nil])
    ary.sort_by{|el| el[0] }
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

  def similar(similarity=1, count=3)
    Photo.where("HAMMINGDISTANCE(#{self.filename}, filename) < ?", similarity)
      .limit(count)
      .order("HAMMINGDISTANCE(#{self.filename}, filename)")
  end

  def similarity(photo)
    Phashion.hamming_distance(photo.filename.to_i, self.filename.to_i)
  end

  def identical()
    identical_photos = similar 1, 1
    if identical_photos.count > 0
      true
    end
  end



  def import(path)
    self.import_path = path
    self.set_exif
    self.process
  end

  def set_exif(path=false)

    raise "File does not exist" unless File.exist?(self.import_path)

    exif = MiniExiftool.new(self.import_path, opts={:numerical=>true})
    if exif.datetimeoriginal.blank?
      exif.datetimeoriginal = File.ctime(self.import_path)
      exif.save
      Rails.logger.debug "exif.datetimeoriginal was set to #{exif.datetimeoriginal}"
    end
    self.date_taken = exif.datetimeoriginal
    self.longitude = exif.gpslongitude
    self.latitude = exif.gpslatitude
    self.make = exif.make
    self.model = exif.model
    self
  end

  def process( clone_mode = 'copy')
    raise "File does not exist" unless File.exist?(self.import_path)

    @phash = Phashion::Image.new(self.import_path)
    self.filename = @phash.fingerprint

    #Check if file already exists in system (db and file)
    if self.identical
      raise "Photo already exists: #{self.import_path}"
    end

    set_paths
    set_attributes
    handle_file(clone_mode)
    create_photos
  end

  def locate
    Location.locate_photo(self)
  end


  def handle_file(clone_mode)
    FileUtils.mkdir_p @absolute_path_original unless File.exist?(@absolute_path_original)
    if clone_mode == 'copy'
      FileUtils.cp self.import_path, File.join(@absolute_path_original, self.filename + self.file_extension)
    else
      File.rename self.import_path, File.join(@absolute_path_original, self.filename + self.file_extension)
    end
  end

private

  def create_photos
    FileUtils.mkdir_p @absolute_path_clones unless File.exist?(@absolute_path_clones)

    resize_photo("_lg", IMAGE_LARGE)
    resize_photo("_md", IMAGE_MEDIUM)
    create_thumbnail
  end

  def set_attributes
    @image = MiniMagick::Image.open(self.import_path)
    self.original_width = @image.width
    self.original_height = @image.height
    self.file_size = @image.size
    self.file_extension = ".jpg"
    self.file_thumb_path = @relative_path_clones
    self.path = @relative_path_original
  end

  def get_date_path()
    date_path = File.join(
      self.date_taken.strftime("%Y"),
      self.date_taken.strftime("%m"),
      self.date_taken.strftime("%d")
    )
    return date_path
  end

  def set_paths
    @date_path = get_date_path
    @relative_path_clones = File.join('phototank', 'thumbs', @date_path)
    @relative_path_original = File.join('phototank', 'originals', @date_path)
    #Create absolute path for thumbs in master archive
    @absolute_path_clones = File.join(Catalog.master.path, 'phototank', 'thumbs', @date_path)
    #Create absolute path for originals in master archive
    @absolute_path_original = File.join(Catalog.master.path, 'phototank', 'originals', @date_path)
  end

  def create_thumbnail()

    dst = File.join(@absolute_path_clones, self.filename + "_tm" + self.file_extension)
    src = File.join(@absolute_path_original, self.filename + self.file_extension)
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", src]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << dst
    end
  end

  def resize_photo(suffix, size)
    file_path = File.join(@absolute_path_clones, self.filename + suffix + self.file_extension)
    if not File.exist?(file_path)
      @image.resize size
      @image.write file_path
    end
  end

  def photo_exist( date_taken)

    existing_photo = self.identical
    if existing_photo.present?
        @phash = Phashion::Image.new(self.import_path)
        phash_existing_photo = Phashion::Image.new(existing_photo.absolutepath)
        @phash.duplicate?(phash_existing_photo)
    else
      false
    end
  end
end
