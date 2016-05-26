catalog_list = [
  ['Master', '/Users/martinhinge/Pictures/phototank/master', ['/Users/martinhinge/Pictures/pics/watch'], true, 'MasterCatalog',nil,nil],
  ['Slave from Albums', '/Users/martinhinge/Pictures/phototank/slavealb', nil, false, 'LocalCatalog', nil, [1,2]],
  ['Slave from Catalogs', '/Users/martinhinge/Pictures/phototank/slavecat', nil, false, 'LocalCatalog', 1 ,nil]
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

photos = [
  ["a", "2015-01-01 00:10:18", "phototank/originals/2015/01/01", "phototank/thumbs/2015/01/01", ".jpg", 234, 2, "LGE", "Nexus 6", 1920, 2550, 151.2083892778, -33.8440017500, 0, "14514088157669143404"],
  ["b", "2015-01-01 00:10:18", "phototank/originals/2015/01/01", "phototank/thumbs/2015/01/01", ".jpg", 234, 2, "LGE", "Nexus 6", 1920, 2550, 151.2083892778, -33.8440017500, 0, "14514088157669143404"],
  ["c", "2015-01-01 00:10:18", "phototank/originals/2015/01/01", "phototank/thumbs/2015/01/01", ".jpg", 234, 2, "LGE", "Nexus 6", 1920, 2550, 151.2083892778, -33.8440017500, 0, "14514088157669143404"],
  ["d", "2015-01-01 00:10:18", "phototank/originals/2015/01/01", "phototank/thumbs/2015/01/01", ".jpg", 234, 2, "LGE", "Nexus 6", 1920, 2550, 151.2083892778, -33.8440017500, 0, "14514088157669143404"],
  ["e", "2015-01-01 00:10:18", "phototank/originals/2015/01/01", "phototank/thumbs/2015/01/01", ".jpg", 234, 2, "LGE", "Nexus 6", 1920, 2550, 151.2083892778, -33.8440017500, 0, "14514088157669143404"]
]
  photos.each do |filename, date_taken, path, file_thumb_path, file_extension, file_size, location_id, make, model, original_height, original_width, longitude, latitude, status, phash|
    Photo.create(
     filename: filename,
     date_taken: date_taken,
     path: path,
     file_thumb_path: file_thumb_path,
     file_extension: file_extension,
     file_size: file_size,
     location_id: location_id,
     make: make,
     model: model,
     original_height: original_height,
     original_width: original_width,
     longitude: longitude,
     latitude: latitude,
     status: status,
     phash: phash
      )
    end


    instances = [
      [1, 1, "path", 123, "2015-01-01 00:10:18", 0, "sd"],
      [2, 1, "path", 123, "2015-01-01 00:10:18", 0, "sd"],
      [3, 1, "path", 123, "2015-01-01 00:10:18", 0, "sd"],
      [4, 1, "path", 123, "2015-01-01 00:10:18", 0, "sd"],
      [5, 1, "path", 123, "2015-01-01 00:10:18", 0, "sd"],
    ]
      instances.each do |photo_id, catalog_id, path, size, modified, status, rev|
        Instance.create(
          photo_id: photo_id,
          catalog_id: catalog_id,
          path: path,
          size: size,
          modified: modified,
          status: status,
          rev: rev
          )
        end
