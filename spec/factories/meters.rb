# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meter do
    # car_id 1
    association :car, factory: :car
    date "2013-03-12"
    meter 1
    mileage 1
    riding_mileage 1
    riding_count 1
    meter_fare_count 1
  end
end
