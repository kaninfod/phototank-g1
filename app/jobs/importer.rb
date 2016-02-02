class Importer
  @queue = :import

  def self.perform(path, catalog_id)

    begin 
      objid = 0
      Dir.glob("#{path}/*.jpg").each do |import_file_path|     
        if File.file?(import_file_path)
          photo = Photo.new
          photo.status = 1
          $redis.set objid, photo.attributes.to_json
          objid = objid + 1
          photo.save
          Resque.enqueue(Exifer, import_file_path, catalog_id, photo.id, objid)
          Resque.enqueue(Locator, photo.id, objid)
          Resque.enqueue(PhotoProcessor, photo.id, import_file_path, objid)
        end
      end
    rescue Exception => e 
      raise "An error occured while setting up the Importer: #{e}"
    end
        
  end
end
