class FixFilenameToPhashion < ActiveRecord::Migration
  def change
    Photo.find_each do |photo|
      if photo.filename.length > 60
        phash = Phashion::Image.new(photo.absolutepath)
        new_filename = phash.fingerprint.to_s
        File.rename photo.absolutepath, File.join(File.dirname(photo.absolutepath), new_filename + ".jpg")
        File.rename photo.small_filename, File.join(File.dirname(photo.small_filename), new_filename + "_tm" + ".jpg")
        File.rename photo.medium_filename, File.join(File.dirname(photo.medium_filename), new_filename + "_md" + ".jpg")
        File.rename photo.large_filename, File.join(File.dirname(photo.large_filename), new_filename + "_lg" + ".jpg")
        photo.filename = new_filename
        photo.save


      end

    end
  end
end
