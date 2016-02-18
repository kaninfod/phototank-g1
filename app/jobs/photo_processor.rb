class PhotoProcessor
  include Resque::Plugins::UniqueJob
  @queue = :import

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '480x680'
  IMAGE_LARGE = '1024x1200'


  def self.perform(path)

    begin

      photo = Photo.new
      photo.import_path = path
      photo.set_exif
      photo.process
      photo.save
      instance = photo.instances.new
      instance.catalog_id = Catalog.master.id
      instance.save
      Resque.enqueue(Locator, photo.id)

    rescue MiniMagick::Invalid => e
      Rails.logger.debug  "#{e}"
    rescue Exception => e
      #Rails.logger.debug  "#{e}"
      raise "An error occured while executing the PhotoProcessor: #{e}"
    end
  end
end
