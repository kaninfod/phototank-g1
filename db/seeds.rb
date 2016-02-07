catalog_list = [
  ['Master', '/Users/martinhinge/Downloads/master', '/Users/martinhinge/Downloads/pics/watch', true, 'LocalCatalog'],
  ['Slave', '/Users/martinhinge/Downloads/slave', '/Users/martinhinge/Downloads/pics/watch', true, 'LocalCatalog']
]

catalog_list.each do |name, path, watch_path, default, type|
  Catalog.create( 
    name: name,
    path: path,
    watch_path: watch_path,
    default: default,
    type: type
    )
  end

  