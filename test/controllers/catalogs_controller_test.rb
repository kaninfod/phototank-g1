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


end
