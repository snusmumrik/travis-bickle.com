# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    user
    sequence(:name) {|n| "name#{n}"}
    base_fare 430
    meter_fare 60
    sequence(:access_token) {|n| "access_token#{n}"}
    sequence(:device_token) {|n| "device_token#{n}"}
    deleted_at nil

    factory :car_with_location do
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to them
      after(:create) do |car|
        create(:location, car: car)
      end
    end
  end
end
