class UtilSetSetting < ResqueJob
  @queue = :import

  def self.perform(klass, id, setting, value)

    begin
      cls = Object.const_get(klass)
      obj = cls.find(id)
      obj.settings[setting.to_sym] = value
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end

end
