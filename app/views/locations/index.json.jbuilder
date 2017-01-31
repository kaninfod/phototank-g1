json.locations @locations do |location|
  json.id   location.id
  json.country   location.country
  json.map_url   location.map_url
  json.count   location.photos.count
  json.address   location.address
end

json.pagi will_paginate
