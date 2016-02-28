require 'dropbox_sdk'
class DropboxCatalog < Catalog
serialize :ext_store_data, Hash

  def import(use_resque=true)
    if not self.sync_from_catalog.blank?
        Resque.enqueue(LocalCloneInstancesFromCatalogJob, self.id, self.sync_from_catalog)
    end
  end

  def import_photo(photo_id)

    photo = Photo.find(photo_id)
    dropbox_path = File.join(photo.path, photo.filename + photo.file_extension)

    response = self.create_folder(photo.path)
    response = self.add_file(photo.absolutepath, dropbox_path)
    instance = photo.instances.where(catalog_id: self.id).first
    instance.catalog_id = self.id
    instance.path = response["path"]
    instance.size = response["bytes"]
    instance.modified = response["modified"]
    instance.status = 0
    instance.save
  end

  # def clone_instances_from_catalog(from_catalog_id=self.sync_from_catalog)
  #   Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
  #     new_instance = Instance.new
  #     new_instance.catalog_id = self.id
  #     new_instance.photo_id = instance.photo_id
  #     begin
  #       new_instance.save
  #     rescue ActiveRecord::RecordNotUnique
  #       logger.debug "instance exists"
  #     end
  #   end
  # end

  # def import_files(use_resque=true)
  #   photos.each do |photo|
  #     if use_resque
  #       Resque.enqueue(DropboxSynchronizer, "import_files", {:photo_id => photo.id, :catalog_id => self.id})
  #     else
  #       copy_file(photo.id)
  #     end
  #   end
  # end

  #
  # def copy_files(photo_id)
  #
  # end




  def online
    true
  end

  def appkey=(new_appkey)
    self.ext_store_data = self.ext_store_data.merge({:appkey => new_appkey})
  end

  def appkey
    self.ext_store_data[:appkey]
  end

  def appsecret=(appsecret)
    self.ext_store_data = self.ext_store_data.merge({:appsecret => new_appsecret})
  end

  def appsecret
    self.ext_store_data[:appsecret]
  end

  def redirect_uri=(new_redirect_uri)
    self.ext_store_data = self.ext_store_data.merge({:redirect_uri => new_redirect_uri})
  end

  def redirect_uri
    self.ext_store_data[:redirect_uri]
  end

  def access_token=(new_access_token)
    self.ext_store_data = self.ext_store_data.merge({:access_token => new_access_token})
  end

  def access_token
    self.ext_store_data[:access_token]
  end

  def user_id=(new_user_id)
    self.ext_store_data = self.ext_store_data.merge({:user_id => new_user_id})
  end

  def user_id
    self.ext_store_data[:user_id]
  end

  def client
    DropboxClient.new(self.access_token)
  end

  def account_info
    self.client.account_info
  end

  def metadata(path)
    begin
      self.client.metadata(path)
    rescue

    end
  end

  def add_file(local_path, dropbox_path)

    self.client.put_file(dropbox_path, open(local_path), overwrite=true)
  end


  def add_file_in_chunks(dropbox_path, local_path)


    local_file_path = local_path
    dropbox_target_path = dropbox_path
    chunk_size = 4*1024*1024
    local_file_size = File.size(local_file_path)
    uploader = self.client.get_chunked_uploader(File.new(local_file_path, "r"), local_file_size)
    retries = 0
    puts "Uploading..."

    while uploader.offset < uploader.total_size
      begin
        uploader.upload(chunk_size)
      rescue DropboxError => e
        if retries > 10
          puts "- Error uploading, giving up."
          break
        end
        puts "- Error uploading, trying again..."
        retries += 1
      end
    end
    puts "Finishing upload..."
    uploader.finish(dropbox_target_path)
    byebug
    puts "Done."
  end

  def create_folder(path)
    begin
      self.client.file_create_folder(path)
    rescue DropboxError => e
      self.metadata(path)
    end
  end

  def sync
    photos.each do |photo|
       Resque.enqueue(DropboxSynchronizer, photo.id)
    end
  end

  def online
    true
  end




end
