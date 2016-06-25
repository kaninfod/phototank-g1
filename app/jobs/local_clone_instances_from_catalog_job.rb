class LocalCloneInstancesFromCatalogJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(to_catalog_id, from_catalog_id)

    begin
      
      Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
        if not Instance.exists? photo_id:instance.photo_id, catalog_id:to_catalog_id
          new_instance = Instance.create(photo_id:instance.photo_id, catalog_id:to_catalog_id)
        end
      end
      Resque.enqueue(LocalSpawnImportJob, to_catalog_id)
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
