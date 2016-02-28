class LocalImportPhotoJob
  include Resque::Plugins::UniqueJob
  @queue = :local



  def self.perform(catalog_id, photo_id)
    begin
      Catalog.find(catalog_id).import_photo(photo_id)
    rescue Exception => e

      raise "An error occured while executing the PhotoProcessor: #{e}"
    end
  end
end
