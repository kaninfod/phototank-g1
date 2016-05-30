class DeletePhoto < ResqueJob
  @queue = :utility

  def self.perform(photo_id)

    begin
      Photo.find(photo_id).destroy
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
