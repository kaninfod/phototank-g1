class ResqueJob

  def self.after_perform(*args)
    @job.update(
      status: 0 ,
      completed_at: Time.now
    )
  end

  def self.before_perform(*args)
    @job = Job.create(
      job_type:   self.name,
      arguments:  args,
      queue:      @queue,
      status:     1 #started
    )
  end

end
