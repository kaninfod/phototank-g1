class MasterCatalog < Catalog
  validates :type, uniqueness: true
  def import

    begin
      self.watch_path.each do |import_path|
        if File.exist?(import_path)
          Resque.enqueue(SpawnImportMaster, import_path, photo_id = nil, import_mode=self.import_mode)
        else
          logger.debug "path #{import_path} did not exist"
        end
      end
      return true
    rescue Exception => e
      raise e
    end
  end

  def online
    File.exist?(self.path)
  end

  def delete_photo(photo_id)
    pf = PhotoFilesApi::Api::new
    begin
      photo = self.photos.find(photo_id)

      pf.destroy photo.tm_id
      pf.destroy photo.md_id
      pf.destroy photo.lg_id
      pf.destroy photo.org_id

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
