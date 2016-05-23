#
# status meaning:
#   status = 1 means date_taken was changes
#   status = 2 means photo was rotated
#

class Photo < ActiveRecord::Base
  validate :date_taken_is_valid_datetime
  before_destroy :_delete
  before_update :move_by_date, if: :date_taken_changed?
  belongs_to :location
  has_many :instances
  has_many :catalogs, through: :instances

  reverse_geocoded_by :latitude, :longitude

  attr_accessor :import_path

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
  scope :years, -> {
    sql = "select distinct(year(date_taken)) as value from photos order by value;"
    find_by_sql(sql)
  }
  scope :months, -> (year) {
    sql = "select distinct(month(date_taken)) as value from photos where year(date_taken) = #{year} order by value;"
    find_by_sql(sql)
  }
  scope :days, -> (year, month) {
    sql = "select distinct(day(date_taken)) as value from photos where year(date_taken) = #{year} and month(date_taken) = #{month} order by value;"
    find_by_sql(sql)
  }

  def date_taken_is_valid_datetime
    if ((DateTime.parse(date_taken.to_s) rescue ArgumentError) == ArgumentError)
      errors.add(:date_taken, 'must be a valid datetime')
    end
  end

  def validate_files(catalog_id=1)
    catalog_path = self.catalog(catalog_id).path

    org = File.exist?(original_filename)
    sm = File.exist?(small_filename)
    md = File.exist?(medium_filename)
    lg = File.exist?(large_filename)

    return org & lg & md & sm
  end

  def date_taken_formatted
    date_taken.strftime("%b %d %Y %H:%M:%S")
  end

  def delete
    Resque.enqueue(DeletePhoto, self.id)
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

    _catalog_path = Rails.cache.fetch("catalog/#{catalog_id}/path", expires_in: 2.hours) do
      self.catalog(catalog_id).path
    end

    _thumb_path = self.file_thumb_path
    _filename = self.filename
    _suffix = "_tm"
    _extension = self.file_extension

    small_filename = File.join(_catalog_path, _thumb_path, _filename + _suffix + _extension)
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

  def locate
    Location.locate_photo(self)
  end

  def rotate(degrees)
    Resque.enqueue(PhotoRotate, self.id, degrees.to_i)
  end

  def update_exif
    #Get from the original only
    exif = MiniExiftool.new(self.absolutepath, opts={:numerical=>true})
    #update each piece of exif data that can be changed
    exif.datetimeoriginal = self.date_taken.strftime("%Y:%m:%d %H:%M:%S")
    exif.imageuniqueid = self.filename

    if not self.location.nil?
      exif.gpslatitude = self.location.latitude.to_s
      exif.gpslongitude = self.location.longitude.to_s
    end

    exif["usercomment"] = "This photo is handled by PhotoTank as of #{self.date_taken.strftime("%Y:%m:%d %H:%M:%S")}"
    #...

    #save exif back to the photo
    exif.save
  end

  def set_phash

    if !self.import_path.blank?
      _path = self.import_path
    else
      _path = self.absolutepath
    end

    phash = Phashion::Image.new(_path)
    self.filename = self.phash = phash.fingerprint

  end

  private
    def move_by_date
      Resque.enqueue(PhotoMoveByDate, self.id)
    end

    def _delete
      #Always call destroy!! this is called by the callback.
      begin
        self.instances.each do |instance|
          instance.destroy
        end
      rescue Exception => e
        logger.debug "#{e}"
      end
    end


end
