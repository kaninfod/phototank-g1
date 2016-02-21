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
    master_catelog = Catalog.new(
      type:"MasterCatalog",
      name:"master",
      default:true,
      watch_path: [File.join(Rails.root, "test/test_files/import/path_a")],
      path: File.join(Rails.root, "test/test_files/store/master")
       )
    assert_difference "Catalog.count" do
        master_catelog.save
    end

    #import 5 photos to master
    assert_difference "Photo.count", 5 do
      wp_path = master_catelog.watch_path[0]
      Dir.glob("#{wp_path}/**/*.jpg").each do |import_file_path|
        if File.file?(import_file_path)
          p = Photo.new
          p.import(import_file_path)
          p.save
          instance = p.instances.new
          instance.catalog_id = Catalog.master.id
          instance.save
        end
      end
    end

    master_catelog.photos.each do |photo|
      assert File.exist?(photo.absolutepath)
    end

    #create local
    local_catelog = Catalog.new(
       type:"LocalCatalog",
       name:"Local-catalog-clone",
       sync_from_catalog: master_catelog.id,
       path: File.join(Rails.root, "test/test_files/store/local")
        )
    assert_difference "Catalog.count" do
      local_catelog.save
    end

    #clone local from master
    assert_difference "local_catelog.instances.count", 5 do
      local_catelog.import_from_catalog
    end

    local_catelog.sync_files(false)
    files = []
    local_catelog.photos.each do |photo|
      files.push(photo.absolutepath(local_catelog.id))
      assert File.exist?(photo.absolutepath(local_catelog.id))
    end


    assert_difference "local_catelog.instances.count", -5 do
      local_catelog.destroy
    end

    files.each do |path|
      assert_not File.exist?(path)
    end



  end

end
