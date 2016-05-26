module ImportPhotoHelper

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'


  def import_flow2(path, import_mode=true)
    data = {}

    #get phash and check if the photo already exists in the database
    phash = Phashion::Image.new(path)
    data[:phash] = phash.fingerprint

    if Photo.exists(data[:phash])
      raise "Photo already exists: #{path}"
    end

    #Create tempfiles for all photos to be created
    @org_file = Tempfile.new("org")
    @tm_file = Tempfile.new("thumb")
    @lg_file = Tempfile.new("large")
    @md_file = Tempfile.new("medium")

    begin
      #set the original file to the tempfile
      @org_file.write File.open(path).read ; :ok

      #Get metadata from photo
      @image = MiniMagick::Image.open(@org_file.path)
      data[:original_width] = @image.width
      data[:original_height] = @image.height
      data[:file_size] = @image.size
      data[:file_extension] = ".jpg"

      #Get EXIF data from photo
      exif = MiniExiftool.new(@org_file.path, opts={:numerical=>true})
      data[:longitude] = exif.gpslongitude
      data[:latitude] = exif.gpslatitude
      data[:make] = exif.make
      data[:model] = exif.model



      #Set data_taken; either from EXIF or from file timestamp
      if exif.datetimeoriginal.blank?
        exif.datetimeoriginal = data[:date_taken] = File.ctime(@org_file.path)

      else
        data[:date_taken]= exif.datetimeoriginal
      end
      exif["usercomment"] = "This photo is handled by PhotoTank as of #{DateTime.now.strftime("%Y.%m.%d %H:%M:%S")}"
      exif.imageuniqueid = data[:phash]
      exif.save

      #Generate a date hash to be usen by the photofile model
      datehash = generate_datehash(data[:date_taken])

      #Create thumbnail and store it to the photofile
      if create_thumbnail()
        datehash[:type] = "tm"
        ps = Photofile.create(path: @tm_file.path, datehash: datehash)
        data[:thumb_id] = ps.id
      end

      #Create medium photo and store it to the photofile
      if resize_photo(@md_file.path, IMAGE_MEDIUM)
        datehash[:type] = "md"
        ps = Photofile.create(path: @md_file.path, datehash: datehash)
        data[:medium_id] = ps.id
      end

      #Create large photo and store it to the photofile
      if resize_photo(@lg_file.path, IMAGE_LARGE)
        datehash[:type] = "lg"
        ps = Photofile.create(path: @lg_file.path, datehash: datehash)
        data[:large_id] = ps.id
      end

      #Put the original photo in photofile
      datehash[:type] = "org"
      ps = Photofile.create(path: @org_file.path, datehash: datehash)
      data[:original_id] = ps.id

      #Delete the source if import_mode is set
      if import_mode
        FileUtils.rm path
      end

    ensure
      #Close and unlink all tempfiles
      @org_file.close
      @org_file.unlink

      @tm_file.close
      @tm_file.unlink

      @lg_file.close
      @lg_file.unlink

      @md_file.close
      @md_file.unlink
    end

    return data
  end

  def generate_datehash(date)
      datestring = date.strftime("%Y%m%d%H%M%S")
      unique = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(5).next.join

      datehash = {
        :datestring=>datestring,
        :unique=>unique,
        :year=>date.year,
        :month=>date.month,
        :day=>date.day
      }
      return datehash
  end

  def create_thumbnail()

    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", @org_file.path]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << @tm_file.path
    end
    return true
  end

  def resize_photo(path, size)
    @image.resize size
    @image.write path
    return true
  end

end
