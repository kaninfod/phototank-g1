class MasterImportSpawn < AppJob
  include Resque::Plugins::UniqueJob
  queue_as :import

  def perform(path, photo_id= nil, import_mode=true)
    begin

      whitelist = "{jpg}"
      UtilSetSetting.perform_later 'MasterCatalog', Catalog.master.id, 'updating', true

      Dir.glob("#{path}/**/*.#{whitelist}").each do |import_file_path|
        if File.file? import_file_path
          MasterImportPhoto.perform_later import_file_path, photo_id, import_mode
        else
          raise "no file to import: #{import_file_path}"
        end
      end

      UtilSetSetting.perform_later 'MasterCatalog', Catalog.master.id, 'updating', false

    rescue Exception => e
      @job_db.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job_db.id}. Error: #{e}"
      return
    end

  end




end
