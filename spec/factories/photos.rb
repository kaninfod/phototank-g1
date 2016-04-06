FactoryGirl.define do

  factory :photo do
    sequence :filename do |n|
      "#{n}234567890"
    end
    date_taken "2014-01-02 12:32:32"
  end


end
