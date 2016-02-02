catalog_list = [
  ['Master', '/Users/martinhinge/Downloads/pics', '/Users/martinhinge/Downloads/pics/watch', true]
]

catalog_list.each do |name, path, watch_path, default|
  Catalog.create( 
    name: name,
    path: path,
    watch_path: watch_path,
    default: default
    )
  end

    





    
