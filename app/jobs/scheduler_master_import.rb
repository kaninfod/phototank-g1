class SchedulerMasterImport < ResqueJob
  @queue = :import

  def self.perform()
    begin
      master = Catalog.master
      master.import
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end

end
