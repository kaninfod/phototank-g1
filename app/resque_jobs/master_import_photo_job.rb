class MasterImportPhotoJob < ResqueJob
  include Resque::Plugins::UniqueJob
  include PhotoFilesApi
  @queue = :import

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'

  def self.perform(import_path, photo_id=false, import_mode=true)

    begin
      ##photo_id = Catalog.master.import_photo(import_path, photo_id, import_mode)

      raise "File does not exist" unless File.exist?(import_path)

      data = import_flow(import_path, import_mode)

      #If a photo id was supplied then update that photo
      if not photo_id
        photo = Photo.new
      else
        photo = Photo.find(photo_id)
      end
      photo.update(data)

      instance = Instance.create(
        photo_id: photo.id,
        catalog_id: Catalog.master.id
      )

      Resque.enqueue(Locator, photo.id)

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end
  end


  def self.import_flow(path, import_mode=true)
    data = {}

    pf = PhotoFilesApi::Api::new
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
        datehash[:size] = "tm"

        ps = pf.create(@tm_file.path, datehash)
        if ps != false
          data[:thumb_id] = ps[:id]
        end
      end

      #Create medium photo and store it to the photofile
      if resize_photo(@md_file.path, IMAGE_MEDIUM)
        datehash[:size] = "md"
        ps = pf.create(@md_file.path, datehash)
        if ps != false
          data[:medium_id] = ps[:id]
        end
      end

      #Create large photo and store it to the photofile
      if resize_photo(@lg_file.path, IMAGE_LARGE)
        datehash[:size] = "lg"
        ps = pf.create(@lg_file.path, datehash)
        if ps != false
          data[:large_id] = ps[:id]
        end
      end

      #Put the original photo in photofile
      datehash[:size] = "org"
      ps = pf.create(@org_file.path, datehash)
      if ps != false
        data[:original_id] = ps[:id]
      end
    
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

  def self.generate_datehash(date)
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

  def self.create_thumbnail()
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-size", "200x200", @org_file.path]
      convert.merge! ["-thumbnail", "125x125^"]
      convert.merge! ["-gravity", "center"]
      convert.merge! ["-extent", "125x125", "+profile", "'*'"]
      convert << @tm_file.path
    end
    return true
  end

  def self.resize_photo(path, size)
    @image.resize size
    @image.write path
    return true
  end

end
