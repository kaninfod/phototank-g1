
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
      #FileUtils.rm self.photos.find(photo_id).original_filename, :force => true
      photo = self.photos.find(photo_id)
      FileUtils.rm photo.large_filename, :force => true
      FileUtils.rm photo.medium_filename, :force => true
      FileUtils.rm photo.small_filename, :force => true

      bin_path = File.join(self.path, "bin")
      FileUtils.mkdir_p bin_path unless File.exists? bin_path
      File.rename photo.original_filename, File.join(bin_path, "#{photo.filename}#{photo.file_extension}")
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
