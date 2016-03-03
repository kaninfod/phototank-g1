class MasterSpawnImportJob
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(path)

    begin
      #Dir['**/*.jpg']
      Dir.glob("#{path}/**/*.jpg").each do |import_file_path|
        if File.file?(import_file_path)
          Resque.enqueue(MasterImportPhotoJob, import_file_path)
        end
      end

    rescue Exception => e
      raise "An error occured while spawning the importer: #{e}"
    end

  end
end
