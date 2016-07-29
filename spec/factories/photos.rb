FactoryGirl.define do
  factory :photo do
    date_taken "2014-01-02 12:32:32"

    trait :with_location do
      longitude 80
      latitude 20
    end
  end
end
