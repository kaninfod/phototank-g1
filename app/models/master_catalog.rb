
class MasterCatalog < Catalog
  include ImportPhotoHelper
  validates :type, uniqueness: true
  def import
    begin
      self.watch_path.each do |import_path|
        if File.exist?(import_path)
          Resque.enqueue(MasterSpawnImportJob, import_path, photo_id = nil, import_mode=self.import_mode)
        else
          logger.debug "path #{import_path} did not exist"
        end
      end
      return true
    rescue Exception => e
      raise e
    end
  end

  def import_photo(import_path, photo_id=false, import_mode=true)

    begin
      #if the file we're trying to import doesn't exsist then forget about it
      raise "File does not exist" unless File.exist?(import_path)

      data = import_flow2(import_path, import_mode)
      #If a photo id was supplied then update that photo
      if not photo_id
        @photo = Photo.new
      else
        @photo = Photo.find(photo_id)
      end
      @photo.update(data)

      instance = Instance.create(
        photo_id: @photo.id,
        catalog_id: self.id
      )

      #update exif data mainly with date and phash
      #@photo.update_exif
      return @photo.id

    rescue Exception => e
      raise e
    end
  end

  def online
    File.exist?(self.path)
  end

  def migrate
    path = self.path

    self.photos.each do |photo|

      Rails.logger.warn "migrating photo with ID #{photo.id}"
      #original
      filename = "#{photo.filename}#{photo.file_extension}"
      filepath = File.join(path, photo.path, filename)
      datehash = generate_datehash(photo.date_taken)
      datehash[:type] = "org"
      ps_org = Photofile.create(path: filepath, datehash: datehash)
      photo.update(original_id:ps_org.id)

      #large
      filename = "#{photo.filename}_lg#{photo.file_extension}"
      filepath = File.join(path, photo.file_thumb_path, filename)
      datehash = generate_datehash(photo.date_taken)
      datehash[:type] = "lg"
      ps_lg = Photofile.create(path: filepath, datehash: datehash)
      photo.update(large_id:ps_lg.id)

      #medium
      filename = "#{photo.filename}_md#{photo.file_extension}"
      filepath = File.join(path, photo.file_thumb_path, filename)
      datehash = generate_datehash(photo.date_taken)
      datehash[:type] = "md"
      ps_md = Photofile.create(path: filepath, datehash: datehash)
      photo.update(medium_id:ps_md.id)


      #thumbnail
      filename = "#{photo.filename}_tm#{photo.file_extension}"
      filepath = File.join(path, photo.file_thumb_path, filename)
      datehash = generate_datehash(photo.date_taken)
      datehash[:type] = "tm"
      ps_tm = Photofile.create(path: filepath, datehash: datehash)
      photo.update(thumb_id:ps_tm.id)

      photo.update(phash:photo.filename)
      photo.update(status:-1003)


    end



  end

  def delete_photo(photo_id)
    begin
      photo = self.photos.find(photo_id)
      Photofile.find(photo.thumb_id).update(status:-1)
      Photofile.find(photo.medium_id).update(status:-1)
      Photofile.find(photo.large_id).update(status:-1)
      Photofile.find(photo.original_id).update(status:-1)

    rescue Exception => e
      Rails.logger.debug "Error: #{e}"
    end
  end

  def self.create_master()
    if MasterCatalog.count == 0
      c = Catalog.new
      c.type = "MasterCatalog"
      c.name = "Master Catalog"
      c.default = true
      c.path = ""
      c.watch_path = []
      c.save
      Rails.cache.delete("master_catalog")
    end
  end

end
