class PhotoRotate < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :utility

  def self.perform(photo_id, degrees)

    begin
      photo = Photo.find(photo_id)
      rotate(photo.original_filename, degrees)
      rotate(photo.large_filename, degrees)
      rotate(photo.medium_filename, degrees)
      rotate(photo.small_filename, degrees)
      photo.update(status: 1)


    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
  private

    def self.rotate(file, degrees)
      MiniMagick::Tool::Convert.new do |convert|
        convert << file
        convert << "-rotate" << degrees
        convert << file
      end
    end

end
