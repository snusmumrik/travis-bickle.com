# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meter do
    report
    sequence(:meter) {|n| n}
    sequence(:mileage) {|n| n}
    sequence(:riding_mileage) {|n| n}
    sequence(:riding_count) {|n| n}
    sequence(:meter_fare_count) {|n| n}
  end
end
