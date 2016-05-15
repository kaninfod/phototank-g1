class LocalCloneInstancesFromCatalogJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(to_catalog_id, from_catalog_id)

    begin
      Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
        new_instance = Instance.new
        new_instance.catalog_id = to_catalog_id
        new_instance.photo_id = instance.photo_id
        begin
          new_instance.save
        rescue ActiveRecord::RecordNotUnique
          Rails.logger.debug "instance exists"
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