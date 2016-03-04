require 'test_helper'

class CatalogTest < ActiveSupport::TestCase
  setup do
    @catalog_master = catalogs(:one)
    FileUtils.mkdir_p File.join(Rails.root, "test/test_files/store/")
  end

  def teardown
    FileUtils.rm_rf(File.join(Rails.root, "test/test_files/store/"))
  end


  test "that a catalog can be created and deleted" do

    #delete currrent master
    assert_difference "Catalog.count", -1 do
        Catalog.master.destroy
    end

    #create new master
    master_catalog = Catalog.new(
      type:"MasterCatalog",
      name:"master",
      default:true,
      watch_path: [File.join(Rails.root, "test/test_files/import/path_a")],
      path: File.join(Rails.root, "test/test_files/store/master")
       )
    assert_difference "Catalog.count" do
        master_catalog.save
    end

    #import 5 photos to master
    assert_difference "Photo.count", 5 do
      wp_path = master_catalog.watch_path[0]
      Dir.glob("#{wp_path}/**/*.jpg").each do |import_file_path|
        if File.file?(import_file_path)
          photo = master_catalog.import_photo(import_file_path)
        end
      end
    end

    master_catalog.photos.each do |photo|
      assert File.exist?(photo.absolutepath)
    end

    #create local
    local_catalog = Catalog.new(
       type:"LocalCatalog",
       name:"Local-catalog-clone",
       sync_from_catalog: master_catalog.id,
       path: File.join(Rails.root, "test/test_files/store/local")
        )
    assert_difference "Catalog.count" do
      local_catalog.save
    end

    #clone local from master
    assert_difference "local_catalog.instances.count", 5 do
      LocalCloneInstancesFromCatalogJob::perform(local_catalog.id, master_catalog.id)
    end

    local_catalog.photos.each do |photo|
      LocalImportPhotoJob::perform(local_catalog.id, photo.id)
    end

    files = []
    local_catalog.photos.each do |photo|
      files.push(photo.absolutepath(local_catalog.id))
      assert File.exist?(photo.absolutepath(local_catalog.id))
    end


    assert_difference "local_catalog.instances.count", -5 do
      local_catalog.destroy
    end

    files.each do |path|
      assert_not File.exist?(path)
    end

  end


  test "that a photo with no exif date can be imported and get new date" do
    import_path = File.join(Rails.root, "test/test_files/master/no_exif_data.jpg")
    photo_id = @catalog_master.import_photo(import_path)
    photo = Photo.find(photo_id)
    exif = MiniExiftool.new(photo.absolutepath, opts={:numerical=>true})

    date1 = Photo.find(photo_id).date_taken
    date2 = File.ctime(import_path)
    date3 = exif.datetimeoriginal

    assert date1 == date2
    assert date1 == date3

  end

  test "can delete photo" do

    import_path = File.join(Rails.root, "test/test_files/master/good_jpeg.jpg")

    c1 = @catalog_master.photos.count

    photo_id = @catalog_master.import_photo(import_path)

    photo = Photo.find(photo_id)
    path1 = photo.absolutepath
    path2 = photo.large_filename
    path3 = photo.medium_filename
    path4 = photo.small_filename

    assert File.exist?(path1)
    assert File.exist?(path2)
    assert File.exist?(path3)
    assert File.exist?(path4)


    c2 = @catalog_master.photos.count

    @catalog_master.delete_photo(photo_id)

    assert_not File.exist?(path1)
    assert_not File.exist?(path2)
    assert_not File.exist?(path3)
    assert_not File.exist?(path4)

    c3 = @catalog_master.photos.count

    assert_equal c1+1, c2
    assert_equal c1, c3

  end

end
