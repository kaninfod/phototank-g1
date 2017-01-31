json.catalogs @catalogs do |catalog|
  json.id   catalog.id
  json.photo_url   catalog.photos.last.url("md")
  json.name   catalog.name
  json.count   catalog.photos.count
end

json.pagi will_paginate
