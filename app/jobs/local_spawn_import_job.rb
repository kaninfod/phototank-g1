class LocalSpawnImportJob
  include Resque::Plugins::UniqueJob
  @queue = :local

  def self.perform(catalog_id)

    begin
      catalog = Catalog.find(catalog_id)
      catalog.photos.each do |photo|
        Resque.enqueue(LocalImportPhotoJob, catalog_id, photo.id)
      end

    rescue Exception => e
      raise "An error occured while setting up the Importer: #{e}"
    end

  end
end
