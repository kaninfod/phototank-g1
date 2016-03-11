class GenerateAlbums < ResqueJob
  @queue = :utility

  def self.perform()

    begin
      Album.generate_year_based_albums
      Album.generate_month_based_albums
      Album.generate_inteval_based_albums
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
