# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    driver
    car
    date "2013-03-12"
    sequence(:meter) {|n| n}
    sequence(:mileage) {|n| n}
    sequence(:riding_mileage) {|n| n}
    sequence(:riding_count) {|n| n}
    sequence(:meter_fare_count) {|n| n}
    sequence(:passengers) {|n| n}
    sequence(:sales) {|n| n}
    sequence(:fuel_cost) {|n| n}
    sequence(:ticket) {|n| n}
    sequence(:account_receivable) {|n| n}
    sequence(:cash) {|n| n}
    sequence(:surplus_funds) {|n| n}
    sequence(:deficiency_account) {|n| n}
    sequence(:advance) {|n| n}
    started_at "2013-03-12 11:24:52"
    finished_at "2013-03-12 11:24:52"
    deleted_at nil
  end
end
