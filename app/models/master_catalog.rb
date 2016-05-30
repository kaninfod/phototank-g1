
class MasterCatalog < Catalog

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

  def import_photo
    Resque.enqueue(MasterImportPhotoJob, import_file_path, photo_id, import_mode)
  end

  def online
    File.exist?(self.path)
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
