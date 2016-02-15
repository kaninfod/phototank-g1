class Importer
  include Resque::Plugins::UniqueJob
  @queue = :import

  def self.perform(path, catalog_id)

    begin
      catalog = Catalog.find(catalog_id)
      objid = 0

      photo = Photo.new
      photo.status = 0

      #Dir['**/*.jpg']
      Dir.glob("#{path}/**/*.jpg").each do |import_file_path|
        if File.file?(import_file_path)
          Resque.enqueue(PhotoProcessor, import_file_path)
        end
      end

    rescue Exception => e
      raise "An error occured while setting up the Importer: #{e}"
    end

  end
end
