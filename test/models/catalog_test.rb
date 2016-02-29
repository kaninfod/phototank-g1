require 'test_helper'

class CatalogTest < ActiveSupport::TestCase
  def teardown
    FileUtils.rm_rf(File.join(Rails.root, "test/test_files/store"))
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
          instance = photo.instances.new
          instance.catalog_id = Catalog.master.id
          instance.save
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

  # test "that a correct date path is returned" do
  #   @photo.date_taken = "2000-02-10"
  #   assert_equal "2000/02/10", @catalog.send(:get_date_path)
  # end



end
