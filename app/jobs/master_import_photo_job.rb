class MasterImportPhotoJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(path)

    begin
      photo = Photo.new
      photo.import_path = path
      #photo.set_exif
      #photo.process
      photo.save
      Catalog.master.import_photo(photo)
      instance = photo.instances.new
      instance.catalog_id = Catalog.master.id
      instance.save
      Resque.enqueue(Locator, photo.id)

    rescue MiniMagick::Invalid => e
      Rails.logger.debug  "#{e}"
    rescue RuntimeError => e
      Rails.logger.debug  "#{e}"
    rescue Exception => e

      raise "An error occured while executing the PhotoProcessor: #{e}"
    end
  end
end
