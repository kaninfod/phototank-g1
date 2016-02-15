class Locator
  include Resque::Plugins::UniqueJob
  @queue = :utility

  def self.perform(photo_id)

    begin

      @photo = Photo.find(photo_id)
      @photo.locate
    rescue Exception => e
      "An error occured while executing the Locator: #{e}"
    end

  end

end
