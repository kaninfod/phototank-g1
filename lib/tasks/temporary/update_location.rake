namespace :locations do
  desc "Add maps from google"
  task set_maps: :environment do
    locations = Location.where(map_image_id: nil)
    puts "Going to update #{locations.count} locations"

    ActiveRecord::Base.transaction do
      locations.each do |location|
        pf = PhotoFilesApi::Api::new
        response = pf.create location.get_google_map, nil, nil, 'maps'
        location.update(map_image_id: response[:id])
        print "."
      end
    end
    puts " All done now!"
  end
end
