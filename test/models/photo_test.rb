require 'test_helper'
require 'fileutils'


class PhotoTest < ActiveSupport::TestCase

  setup do
    @photo = photos(:one)
    @photo_B = photos(:two)
  end

   test "that an absolutepath is returned" do
     photo = Photo.new
     photo.stubs(:absolutepath).returns("/path/to/my/photo")
     assert_equal "/path/to/my/photo", photo.absolutepath
   end

   test "that an original path is returned" do
     photo = Photo.new
     photo.stubs(:original_filename).returns("/path/to/my/photo")
     assert_equal "/path/to/my/photo", photo.original_filename
   end

   test "that an large path is returned" do
     photo = Photo.new
     photo.stubs(:large_filename).returns("/path/to/my/photo")
     assert_equal "/path/to/my/photo", photo.large_filename
   end

   test "that an medium path is returned" do
     photo = Photo.new
     photo.stubs(:medium_filename).returns("/path/to/my/photo")
     assert_equal "/path/to/my/photo", photo.medium_filename
   end

   test "that an small path is returned" do
     photo = Photo.new
     photo.stubs(:small_filename).returns("/path/to/my/photo")
     assert_equal "/path/to/my/photo", photo.small_filename
   end

   test "that photo returns similarity factor" do
     assert @photo.similarity(@photo_B)
   end

   test "that photo does not exist" do
     none_exist_photo = Photo.new
     none_exist_photo.filename = 233456789
     assert_not none_exist_photo.identical
   end

   test "that photo does exist" do
     assert @photo.identical
   end



   def teardown
     FileUtils.rm_rf(File.join(Rails.root, "test/test_files/store"))
   end

  #  test "that a photo can be imported" do
   #
  #    path = File.join(Rails.root, "test/test_files/import/path_a/IMG_20160215_143124.jpg")
  #    photo = Photo.new
  #    photo.import_path = path
  #    photo.set_exif
  #    photo.process
   #
  #    assert_difference "Photo.count", 1 do
  #      photo.save
  #    end
  #    instance = photo.instances.new
  #    instance.catalog_id = Catalog.master.id
   #
  #    assert_difference "Instance.count", 1 do
  #      instance.save
  #    end
   #
  #    assert File.exist?(photo.original_filename)
  #    assert File.exist?(photo.large_filename)
  #    assert File.exist?(photo.small_filename)
  #    assert File.exist?(photo.medium_filename)
   #
  #  end

end
