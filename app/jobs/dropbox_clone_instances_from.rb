class DropboxCloneInstancesFrom
  @queue = :dropbox

  def self.perform(action, options)

    begin
      case action
      when "import_files"
        catalog = Catalog.find(options["catalog_id"])
        catalog.copy_files(options["photo_id"])
      when "clone_instances_from_catalog"
        catalog = Catalog.find(options["catalog_id"])
        catalog.clone_instances_from_catalog
        catalog.import_files
      end
    rescue Exception => e
      raise "An error while synchonizing to Dropbox: #{e}"
    end
  end


end
