class MasterImportPhotoJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(import_path)

    begin
      photo_id = Catalog.master.import_photo(import_path)
      Resque.enqueue(Locator, photo_id)

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end
  end

end
