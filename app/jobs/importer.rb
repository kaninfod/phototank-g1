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
          
          Resque.enqueue(PhotoProcessor, import_file_path, catalog, photo)
          Resque.enqueue(Locator, photo.id)
        end
      end
    rescue Exception => e 
      raise "An error occured while setting up the Importer: #{e}"
    end
        
  end
end
