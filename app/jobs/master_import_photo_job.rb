class MasterImportPhotoJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(import_path)

    begin
      photo_id = Catalog.master.import_photo(import_path)
      instance = Instance.new
      instance.photo_id = photo_id
      instance.catalog_id = Catalog.master.id
      instance.save
      Resque.enqueue(Locator, photo_id)

    rescue MiniMagick::Invalid => e
      Rails.logger.debug  "#{e}"
    rescue RuntimeError => e
      Rails.logger.debug  "#{e}"
    rescue Exception => e

      raise "An error occured while executing the PhotoProcessor: #{e}"
    end
  end
end
