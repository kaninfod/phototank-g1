FactoryGirl.define do
  factory :photofile do
    path "/Users/martinhinge/rails_projects/phototank/spec/test_files/store/photofile/20160717000000__0Ea6c.jpg"

    after(:build) { |photofile| photofile.class.skip_callback(:create, :before, :import_file) }
  end
end
