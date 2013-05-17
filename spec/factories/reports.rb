# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    driver
    car
    date Date.today
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
    started_at DateTime.now
    finished_at nil
    deleted_at nil

    factory :report_with_ride do
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to them
      after(:create) do |report|
        create_list(:ride, 3, report: report)
      end
    end
  end
end
