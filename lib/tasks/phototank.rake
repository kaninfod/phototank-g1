namespace :phototank do
  desc "TODO"
  task create_master_catalog: :environment do
    MasterCatalog.create_master
  end

  desc "TODO"
  task Add_generic_photo: :environment do
    pf = PhotoFilesApi::Api::new
    ['tm', 'md', 'lg'].each do |ext|
      image_path = File.join(Rails.root,'app','assets','images', "generic_#{ext}.jpg")
      response = pf.create image_path, nil, nil, 'generic_image'
      Setting["generic_image_#{ext}_id"] = response[:id]
    end

  end

end
