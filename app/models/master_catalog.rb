
class MasterCatalog < Catalog
include ImportPhotoHelper

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

  def import_photo(import_path, photo_id= nil, import_mode=true)
    #if the file we're trying to import doesn't exsist then forget about it
    raise "File does not exist" unless File.exist?(import_path)

    #If a photo id was supplied then update that photo
    if photo_id.nil?
      @photo = Photo.new
    else
      @photo = Photo.find(photo_id)
    end

    #set the path of the original photo
    @photo.import_path = import_path

    #Get and set the phash and check if it already exists - if it does then exit
    @photo.set_phash
    if @photo.identical then
      raise "Photo already exists: #{@photo.import_path}"
    end

    set_exif
    process(import_mode=import_mode)

    @photo.save
    instance = Instance.create(
      photo_id: @photo.id,
      catalog_id: self.id
    )

    #update exif data mainly with date and phash
    @photo.update_exif
    #if date_changed
    #  change_exif_data
    #end
    return @photo.id
  end

  def online
    File.exist?(self.path)
  end

  def delete_photo(photo_id)
    begin
      FileUtils.rm((self.photos.find(photo_id).original_filename))
      FileUtils.rm((self.photos.find(photo_id).large_filename))
      FileUtils.rm((self.photos.find(photo_id).medium_filename))
      FileUtils.rm((self.photos.find(photo_id).small_filename))
      self.instances.where(photo_id: photo_id).each{ |instance| instance.destroy}
      Photo.find(photo_id).destroy
    rescue Exception => e
      logger.debug "#{e}"
    end
  end

  def self.create_master()
    c = Catalog.new
    c.type = "MasterCatalog"
    c.name = "Master Catalog"
    c.default = true
    c.path = ""
    c.watch_path = []
    c.save
  end

  private



end
