require 'test_helper'
require 'fileutils'

class PhotoTest < ActiveSupport::TestCase
   test "EXIF gets extracted from good JPEG file" do
     
     master = Rails.root.join('test','test_files', 'master', 'good_jpeg.jpg').to_s
     target = Rails.root.join('test','test_files', 'good_jpeg.jpg').to_s
     FileUtils.cp master, target
     photo = Photo.new
     photo.populate_from_file target
     photo.save     
     
     assert_not_nil photo.longitude
     assert_not_nil photo.latitude
     assert_not_nil photo.date_taken
     assert_not_nil(photo.location)
     assert File.exist?(File.join(photo.default_instance,photo.original_filename))
     assert File.exist?(File.join(photo.default_instance,photo.small_filename))
     assert File.exist?(File.join(photo.default_instance,photo.medium_filename))              
     assert File.exist?(File.join(photo.default_instance,photo.large_filename))
   end
      
   test "EXIF extraction from bad JPEG file" do
     master = Rails.root.join('test','test_files', 'master', 'no_exif_data.jpg').to_s
     target = Rails.root.join('test','test_files', 'no_exif_data.jpg').to_s
     FileUtils.cp master, target
     
     photo = Photo.new
     photo.populate_from_file target
     photo.save
       
     assert_nil photo.longitude
     assert_nil photo.latitude
     assert_nil(photo.location)
     assert_not_nil photo.date_taken
     assert File.exist?(File.join(photo.default_instance,photo.original_filename))
     assert File.exist?(File.join(photo.default_instance,photo.small_filename))
     assert File.exist?(File.join(photo.default_instance,photo.medium_filename))              
     assert File.exist?(File.join(photo.default_instance,photo.large_filename))
   end

   test "EXIF extraction from non JPEG file" do
     master = Rails.root.join('test','test_files', 'master', 'not_jpeg.jpg').to_s
     target = Rails.root.join('test','test_files', 'not_jpeg.jpg').to_s
     FileUtils.cp master, target
     photo = Photo.new
     photo.populate_from_file target

     assert_raise(ActiveRecord::StatementInvalid) {photo.save}     
     assert_nil photo.date_taken
   end
   
   
   
end
