
class LocalSyncAlbum
  @queue = :local_sync

  def self.perform(to_catalog_id, album_id)

    begin
      to_catalog = Catalog.find(to_catalog_id)
      to_catalog.import_from_album(album_id)
      to_catalog.sync_files
    rescue Exception => e

      raise "An error occured : #{e}"
    end
  end


end
