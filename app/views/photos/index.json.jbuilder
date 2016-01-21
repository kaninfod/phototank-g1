json.array!(@photos) do |photo|
  json.extract! photo, :id, :filename, :date_taken, :path
  json.url photo_url(photo, format: :json)
end
