require 'test_helper'
require 'fileutils'


class PhotoTest < ActiveSupport::TestCase

  setup do
    @photo = photos(:one)
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

   test "that photo does exist" do
     assert @photo.send(:photo_exist, @photo.filename, @photo.date_taken)
   end

   test "that photo does not exist" do
     assert_not @photo.send(:photo_exist, "xxx", @photo.date_taken)
   end

   test "that a correct date path is returned" do
     @photo.date_taken = "2000-02-10"
     assert_equal "2000/02/10", @photo.send(:get_date_path)
   end

end
