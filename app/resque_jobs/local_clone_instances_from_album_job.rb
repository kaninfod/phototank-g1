class LocalCloneInstancesFromAlbumJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(catalog_id, from_album_id)

    begin
      from_album = Album.find(from_album_id)

      from_album.photos.each do |photo|
        new_instance = photo.instances.first.dup
        new_instance.catalog_id = catalog_id
        begin
          new_instance.save
        rescue ActiveRecord::RecordNotUnique
          Rails.logger.debug "instance exists"
        end
      end

      Resque.enqueue(LocalSpawnImportJob, catalog_id)
    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
end
