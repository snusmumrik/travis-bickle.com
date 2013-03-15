# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    car
    sequence(:address) {|n| "address#{n}"}
    latitude 1.5
    longitude 1.5
    gmaps true
  end
end
