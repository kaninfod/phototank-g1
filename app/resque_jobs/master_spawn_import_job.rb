class MasterSpawnImportJob < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(path, photo_id= nil, import_mode=true)

    begin

      Dir.glob("#{path}/**/*.jpg").each do |import_file_path|
        if File.file?(import_file_path)
          Resque.enqueue(MasterImportPhotoJob, import_file_path, photo_id, import_mode)
        end
      end

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end




end
