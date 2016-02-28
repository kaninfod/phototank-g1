class LocalCloneInstancesFromAlbumJob
  include Resque::Plugins::UniqueJob
  @queue = :local

  def self.perform(catalog_id, from_album_id)

    begin
      from_album = Album.find(from_album_id)

      from_album.photos.each do |photo|
        new_instance = photo.instances.first.dup
        new_instance.catalog_id = catalog_id
        begin
          new_instance.save
        rescue ActiveRecord::RecordNotUnique
          logger.debug "instance exists"
        end
      end

      Resque.enqueue(LocalSpawnImportJob, catalog_id)
    rescue Exception => e
      raise "An error occured while setting up the Importer: #{e}"
    end

  end
end
