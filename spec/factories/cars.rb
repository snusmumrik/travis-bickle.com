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

    after(:create) do |car|
      create(:location, car: car)
    end
  end
end
