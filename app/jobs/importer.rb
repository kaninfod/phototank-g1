class Importer
  @queue = :import

  def self.perform(path, catalog_id)


    Dir.glob("#{path}/*.jpg").each do |import_file_path|     
      if File.file?(import_file_path)
        photo = Photo.new
        photo.save
        Resque.enqueue(Exifer, import_file_path, catalog_id, photo.id)
        Resque.enqueue(Locator, photo.id)
        
      end
    end
  end
end