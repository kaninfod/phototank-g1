
class PhotoRotate < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :utility

  def self.perform(photo_id, degrees)
    pf = PhotoFilesApi::Api::new
    begin
      photo = Photo.find(photo_id)
      new_phash = 0
      photo.get_photofiles_hash.each do |key, id|
        pf.rotate(id, degrees)
        if key == :original
          new_phash = pf.phash(id)
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
