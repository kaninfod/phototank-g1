class LocalImportPhotoJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :local



  def self.perform(catalog_id, photo_id)
    begin
      Catalog.find(catalog_id).import_photo(photo_id)
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end
  end
end
