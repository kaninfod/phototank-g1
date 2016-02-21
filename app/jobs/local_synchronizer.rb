
class LocalSynchronizer
  @queue = :local_sync

  def self.perform(photo_id, catalog_id)

    begin
      Catalog.find(catalog_id).sync(photo_id)
      #photo = Photo.find(photo_id)
      #src = photo.absolutepath
      #dst = File.join(Catalog.find(catalog_id).path, photo.path)
      #copy_file(src, dst) unless File.exist?(photo.absolutepath(catalog_id))
    rescue Exception => e

      raise "An error occured: #{e}"
    end
  end

  def self.copy_file(src, dst)
    FileUtils.mkdir_p dst
    FileUtils.cp src, dst
  end

end
