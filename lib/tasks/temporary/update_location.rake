namespace :locations do
  desc "Add maps from google"
  task set_maps: :environment do
    locations = Location.where(map_image_id: nil)
    puts "Going to update #{locations.count} locations"

    ActiveRecord::Base.transaction do
      pf = PhotoFilesApi::Api::new
      locations.each do |location|
        if location.map_image_id != nil
          response = pf.create location.get_google_map, nil, nil, 'maps'
          location.update(map_image_id: response[:id])
        end
        print "."
      end
    end
    puts " All done now!"
  end
end
