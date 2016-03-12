require 'dropbox_sdk'
class DropboxCatalog < Catalog
serialize :ext_store_data, Hash

  def import(use_resque=true)

    raise "Catalog is not online" unless online
    if not self.sync_from_catalog.blank?
        Resque.enqueue(LocalCloneInstancesFromCatalogJob, self.id, self.sync_from_catalog)
    end
  end

  def import_photo(photo_id)

    photo = Photo.find(photo_id)
    dropbox_path = File.join(photo.path, photo.filename + photo.file_extension)
    byebug
    if not self.exists(dropbox_path)
      response = self.create_folder(photo.path)
      response = self.add_file(photo.absolutepath, dropbox_path)

      instance = photo.instances.where(catalog_id: self.id).first
      instance.catalog_id = self.id
      instance.path = response["path"]
      instance.size = response["bytes"]
      instance.rev = response["rev"]
      instance.modified = response["modified"]
      instance.status = 0
      instance.save
    else
      raise "File exists in Dropbox with same revision id and path"
    end
  end


  def online
    true if access_token
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

    if not defined?(@client)
      @client = DropboxClient.new(self.access_token)
    end
    @client
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

    puts "Done."
  end

  def create_folder(path)
    begin
      self.client.file_create_folder(path)
    rescue DropboxError => e
      self.metadata(path)
    end
  end

  def exists(path)
    response = self.metadata(path)
    if not response.nil?
      if Instance.where(rev: response["rev"]).present?
        return true
      else
        return false
      end
    end
    return false
  end

end
