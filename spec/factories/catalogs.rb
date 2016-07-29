FactoryGirl.define do
  factory :master_catalog do
    name "my_master_catalogx"
    type "MasterCatalog"
    path File.join(Rails.root, '/spec/test_files/target/master')
    watch_path [File.join(Rails.root, '/test/test_files/import/path_a'), File.join(Rails.root, '/test/test_files/import/path_b')]
    sync_from_albums nil
    sync_from_catalog nil
    default true
    import_mode false
  end

  factory :local_catalog do
    name "my_master_catalog"
    type "LocalCatalog"
    path File.join(Rails.root, '/spec/test_files/target/local')
    watch_path nil
    sync_from_albums nil
    sync_from_catalog nil
    default true
    import_mode false
  end

  factory :dropbox_catalog do
    name "my_master_catalog"
    type "DropboxCatalog"
    path File.join(Rails.root, '/test/test_files/store')
    watch_path nil
    sync_from_albums nil
    sync_from_catalog nil
    default true
    import_mode false
  end


end
