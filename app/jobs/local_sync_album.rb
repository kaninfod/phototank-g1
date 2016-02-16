
class LocalSyncAlbum
  @queue = :local_sync

  def self.perform(to_catalog_id, album_id)

    begin
      to_catalog =Catalog.find(to_catalog_id)
      to_catalog.import_from_album(album_id)

    rescue Exception => e

      raise "An error while synchonizing to Dropbox: #{e}"
    end
  end


end
