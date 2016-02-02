class Importer
  @queue = :import

  def self.perform(path, catalog_id)

    begin 
      catalog = Catalog.find(catalog_id)
      objid = 0

      photo = Photo.new
      photo.status = 0

      Dir.glob("#{path}/*.jpg").each do |import_file_path|     
        if File.file?(import_file_path)
          
          #instance = photo.instances.new
          #instance.catalog_id = catalog_id
          $redis.set objid, photo.attributes.to_json
          objid = objid + 1
          #photo.save
          #Resque.enqueue(Exifer, import_file_path, catalog_id, photo.id, objid)
          Resque.enqueue(PhotoProcessor, import_file_path, catalog.path, objid)
          Resque.enqueue(Locator, photo.id)
        end
      end
    rescue Exception => e 
      raise "An error occured while setting up the Importer: #{e}"
    end
        
  end
end
