module ImportPhotoHelper

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'

  def set_exif(path=false)
    raise "File does not exist" unless File.exist?(@photo.import_path)

    exif = MiniExiftool.new(@photo.import_path, opts={:numerical=>true})
    if exif.datetimeoriginal.blank?
      exif.datetimeoriginal = File.ctime(@photo.import_path)
      exif.save
      Rails.logger.debug "exif.datetimeoriginal was set to #{exif.datetimeoriginal}"
    end
    @photo.date_taken = exif.datetimeoriginal
    @photo.longitude = exif.gpslongitude
    @photo.latitude = exif.gpslatitude
    @photo.make = exif.make
    @photo.model = exif.model
  end

  def process(clone_mode = 'copy')
    @phash = Phashion::Image.new(@photo.import_path)
    @photo.filename = @phash.fingerprint

    #Check if file already exists in system (db and file)
    if @photo.identical
      raise "Photo already exists: #{@photo.import_path}"
    end

    set_paths
    set_attributes
    handle_file(clone_mode)
    create_photos
  end

  def set_attributes
    @image = MiniMagick::Image.open(@photo.import_path)
    @photo.original_width = @image.width
    @photo.original_height = @image.height
    @photo.file_size = @image.size
    @photo.file_extension = ".jpg"
    @photo.file_thumb_path = @relative_path_clones
    @photo.path = @relative_path_original
  end

  def get_date_path()
    date_path = File.join(
      @photo.date_taken.strftime("%Y"),
      @photo.date_taken.strftime("%m"),
      @photo.date_taken.strftime("%d")
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

  def handle_file(clone_mode)
    FileUtils.mkdir_p @absolute_path_original unless File.exist?(@absolute_path_original)
    if clone_mode == 'copy'
      FileUtils.cp @photo.import_path, File.join(@absolute_path_original, @photo.filename + @photo.file_extension)
    else
      File.rename @photo.import_path, File.join(@absolute_path_original, @photo.filename + @photo.file_extension)
    end
  end


  def create_photos
    FileUtils.mkdir_p @absolute_path_clones unless File.exist?(@absolute_path_clones)
    resize_photo("_lg", IMAGE_LARGE)
    resize_photo("_md", IMAGE_MEDIUM)
    create_thumbnail
  end

  def create_thumbnail()
    dst = File.join(@absolute_path_clones, @photo.filename + "_tm" + @photo.file_extension)
    src = File.join(@absolute_path_original, @photo.filename + @photo.file_extension)
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", src]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << dst
    end
  end

  def resize_photo(suffix, size)
    file_path = File.join(@absolute_path_clones, @photo.filename + suffix + @photo.file_extension)
    if not File.exist?(file_path)
      @image.resize size
      @image.write file_path
    end
  end
end
