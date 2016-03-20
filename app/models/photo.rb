class Photo < ActiveRecord::Base

  belongs_to :location
  has_many :instances, dependent: :destroy
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

  def locate
    Location.locate_photo(self)
  end

  def rotate(degrees)
    Resque.enqueue(PhotoRotate, self.id, degrees.to_i)
  end
end
