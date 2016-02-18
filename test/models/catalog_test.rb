require 'test_helper'

class CatalogTest < ActiveSupport::TestCase
  def teardown
    FileUtils.rm_rf(File.join(Rails.root, "test/test_files/store"))
  end

  test "that a photo can be imported" do

    path = File.join(Rails.root, "test/test_files/import/path_a/IMG_20160215_143124.jpg")
    photo = Photo.new
    photo.import_path = path
    photo.set_exif
    photo.process

    assert_difference "Photo.count", 1 do
      photo.save
    end
    instance = photo.instances.new
    instance.catalog_id = Catalog.master.id

    assert_difference "Instance.count", 1 do
      instance.save
    end
    assert File.exist?(photo.original_filename)
    assert File.exist?(photo.large_filename)
    assert File.exist?(photo.small_filename)
    assert File.exist?(photo.medium_filename)

  end

end
