class LocalSpawnImportJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(catalog_id)

    begin
      catalog = Catalog.find(catalog_id)
      catalog.not_synchronized.each do |instance|
        Resque.enqueue(LocalImportPhotoJob, catalog_id, instance.photo_id)
      end

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
