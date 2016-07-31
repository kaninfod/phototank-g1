class SchedulerMasterImport < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :import
  # RUN_EVERY = 2.minute
  #
  # after_perform do |job|
  #   self.class.set(wait: RUN_EVERY).perform_later
  # end

  def perform()
    begin
      master = Catalog.master
      master.import
    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end

end
