

  RSpec.configure do |config|
    config.before(:suite) do
      Rails.application.load_seed # loading seeds
    end
  end


  RSpec.describe "Migrate" do

    master = MasterCatalog.first
    master.migrate

    master.photos.each do |photo|

      it {expect(photo.original_id).not_to be_zero}
      p = Photofile.find(photo.original_id)
      it {expect(p.path).not_to be_empty}

      it {expect(photo.large_id).not_to be_zero}
      p = Photofile.find(photo.large_id)
      it {expect(p.path).not_to be_empty}

      it {expect(photo.medium_id).not_to be_zero}
      p = Photofile.find(photo.medium_id)
      it {expect(p.path).not_to be_empty}

      it {expect(photo.thumb_id).not_to be_zero}
      p = Photofile.find(photo.thumb_id)
      it {expect(p.path).not_to be_empty}

      it {expect(photo.status).to eq(-1003)}
      it {expect(photo.phash).to eq(photo.filename)}

    end

  end
