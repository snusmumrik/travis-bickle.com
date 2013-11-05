# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    user
    sequence(:name) {|n| "name#{n}"}
    sequence(:email) {|n| "email#{n}@test.com"}
    password "password"
    password_confirmation "password"
    password_digest "password"
    deleted_at nil

    factory :driver_with_report do
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to them
      after(:create) do |driver|
        # cars = Car.includes(:user).where(["user_id = ?", driver.user_id]).all
        # car = cars[rand(cars.size)]
        create(:report_with_ride, driver: driver)#, car: car)
      end
    end
  end
end
