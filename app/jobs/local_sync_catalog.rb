
class LocalSyncCatalog
  @queue = :local_sync

  def self.perform(to_catalog_id, from_catalog_id)
    begin
      to_catalog = Catalog.find(to_catalog_id)
      to_catalog.import_from_catalog(from_catalog_id)
    rescue Exception => e

      raise "An error occured: #{e}"
    end
  end


end
