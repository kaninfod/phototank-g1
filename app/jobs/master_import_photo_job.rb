class MasterImportPhotoJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(import_path)

    begin
      photo_id = Catalog.master.import_photo(import_path)
      Resque.enqueue(Locator, photo_id)

    rescue MiniMagick::Invalid => e

      ImportError.create(
        error_type: "MasterImportPhotoJob",
        path:  import_path,
        error_message: e)
      Rails.logger.debug  "#{e}"
    rescue RuntimeError => e

      ImportError.create(
        error_type: "MasterImportPhotoJob",
        path:  import_path,
        error_message: e)
      Rails.logger.debug  "#{e}"
    rescue Exception => e
      
      ImportError.create(
        error_type: "MasterImportPhotoJob",
        path:  import_path,
        error_message: e)
      raise "An error occured while importing the photo: #{e}"
    end
  end
end
