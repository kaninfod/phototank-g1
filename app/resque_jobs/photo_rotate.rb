include PhotoFilesApi
class PhotoRotate < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :utility

  def self.perform(photo_id, degrees)

    begin
      photo = Photo.find(photo_id)
      new_phash = 0
      photofile_hash = photo.get_photofiles_hash
      photofile_hash.each do |key, id|
        self.rotate(id, degrees)
        if key == :original
          new_phash = self.phash(id)
        end
      end

      #set and save phash
      photo.update(phash:new_phash)

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
