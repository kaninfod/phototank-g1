require 'test_helper'

class CatalogsControllerTest < ActionController::TestCase
  setup do
    @catalog = catalogs(:one)
    @catalog_local_catalog = catalogs(:two)
    Resque::Job.destroy(:import, MasterImport)
    Resque::Job.destroy(:local_sync, LocalSyncCatalog)
    Resque::Job.destroy(:local_sync, LocalSyncAlbum)
  end

  test "import to master catalog" do
    post :import, {:import_action => 'master', :id => 1}
    assert_equal 2, Resque.size(:import)
    assert_response :redirect
  end

  test "import to local catalog -catalog" do
    post :import, {:import_action => 'local', :id => 2}
    assert_equal 1, Resque.size(:local_sync)
    assert_response :redirect
  end

  test "import to local catalog -album" do
    post :import, {:import_action => 'local', :id => 3}
    assert_equal 2, Resque.size(:local_sync)
    assert_response :redirect
  end

  test "can create master catalog" do
    assert_difference "Catalog.count" do
      get :create, {:catalog => {:name => "catalog name", :type => "MasterCatalog", :path => "/my/path"}}
    end
    assert_response :redirect
  end

  test "can edit master catalog" do
    post :manage, {
      :id => 1,
      :name => "catalog name",
      :type => "MasterCatalog",
      :path => "/my/path",
      :wp_1 => "/me/own/path_a",
      :wp_2 => "/me/own/path_b"
    }
    assert_equal ["/me/own/path_a","/me/own/path_b"], Catalog.find(1).watch_path
    assert_response :redirect
  end

  test "can create local catalog" do
    assert_difference "Catalog.count" do
      get :create, {:catalog => {:name => "catalog name", :type => "LocalCatalog", :path => "/my/path"}}
    end
    assert_response :redirect
  end

  test "can edit local catalog -album" do
    post :manage, {
      :id => 3,
      :name => "catalog name",
      :type => "LocalCatalog",
      :path => "/my/path",
      :sync_from => "album",
      :sync_from_album_id_3 => "3",
      :sync_from_album_id_4 => "4"
    }
    assert_equal ["3", "4"], Catalog.find(3).sync_from_albums
    assert_response :redirect
  end

  test "can edit local catalog -catalog" do
    post :manage, {
      :id => 2,
      :name => "catalog name",
      :type => "LocalCatalog",
      :path => "/my/path",
      :sync_from => "catalog",
      :sync_from_catalog_id => "3"
    }
    assert_equal 3, Catalog.find(2).sync_from_catalog
    assert_response :redirect
  end

  
end
