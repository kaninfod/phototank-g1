
class LocalSynchronizer
  @queue = :local_sync

  def self.perform(action, options)

    begin
      case action

        when "import_files"
          photo_id = options["photo_id"]
          catalog_id = options["catalog_id"]
          Catalog.find(catalog_id).copy_file(photo_id)
        when "clone_instances_from_albums"
          to_catalog_id = options["catalog_id"]
          album_id = options["album_id"]
          to_catalog = Catalog.find(to_catalog_id)
          to_catalog.clone_instances_from_albums(album_id)
          to_catalog.import_files
        when "clone_instances_from_catalog"
          to_catalog_id = options["to_catalog_id"]
          from_catalog_id = options["from_catalog_id"]
          to_catalog = Catalog.find(to_catalog_id)
          to_catalog.clone_instances_from_catalog(from_catalog_id)
          to_catalog.import_files
      end
    rescue Exception => e
      byebug
      raise "An error occured: #{e}"
    end
  end


end
