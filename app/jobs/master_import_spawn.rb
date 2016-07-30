class MasterImportSpawn < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(path, photo_id= nil, import_mode=true)
    begin

      whitelist = "{jpg,JPG}"
      Resque.enqueue(UtilSetSetting, 'MasterCatalog', Catalog.master.id, 'updating', true)

      Dir.glob("#{path}/**/*.#{whitelist}").each do |import_file_path|
        if File.file? import_file_path
          Resque.enqueue(MasterImportPhoto, import_file_path, photo_id, import_mode)
        else
          raise "no file to import: #{import_file_path}"
        end
      end

      Resque.enqueue(UtilSetSetting, 'MasterCatalog', Catalog.master.id, 'updating', false)

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end




end
