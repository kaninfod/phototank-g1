catalog_list = [
  ['Master', '/Users/martinhinge/Downloads/phototank/master', ['/Users/martinhinge/Downloads/pics/watch'], true, 'MasterCatalog',nil,nil],
  ['Slave from Albums', '/Users/martinhinge/Downloads/phototank/slavealb', nil, false, 'LocalCatalog', nil, [1,2]],
  ['Slave from Catalogs', '/Users/martinhinge/Downloads/phototank/slavecat', nil, false, 'LocalCatalog', 1 ,nil]
]

catalog_list.each do |name, path, watch_path, default, type, sync_from_catalog, sync_from_albums|
  Catalog.create(
    name: name,
    path: path,
    watch_path: watch_path,
    default: default,
    type: type,
    sync_from_catalog: sync_from_catalog,
    sync_from_albums: sync_from_albums
    )
  end
