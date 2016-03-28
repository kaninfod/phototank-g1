class PhotoRotate < ResqueJob
  include Resque::Plugins::UniqueJob
  @queue = :utility

  def self.perform(photo_id, degrees)

    begin
      photo = Photo.find(photo_id)

      #store filepaths before setting a new phash
      _file_path_tm = photo.small_filename
      _file_path_md = photo.medium_filename
      _file_path_lg = photo.large_filename
      _file_path_org = photo.original_filename

      #rotate all instances
      rotate(photo.original_filename, degrees)
      rotate(photo.large_filename, degrees)
      rotate(photo.medium_filename, degrees)
      rotate(photo.small_filename, degrees)

      #set and save phash
      photo.set_phash
      photo.save

      #rename files to new phash
      File.rename _file_path_tm, photo.small_filename
      File.rename _file_path_md, photo.medium_filename
      File.rename _file_path_lg, photo.large_filename
      File.rename _file_path_org, photo.original_filename

    rescue Exception => e
      @job.update(job_error: e, status: 2, completed_at: Time.now)
      Rails.logger.warn "Error raised on job id: #{@job.id}. Error: #{e}"
      return
    end

  end
  private

    def self.rotate(file, degrees)
      MiniMagick::Tool::Convert.new do |convert|
        convert << file
        convert << "-rotate" << degrees
        convert << file
      end
    end

end
