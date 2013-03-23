# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ride do
    report
    ride_latitude 1.5
    ride_longitude 1.5
    ride_address "MyString"
    leave_latitude 1.5
    leave_longitude 1.5
    leave_address "MyString"
    passengers 1
    fare 1
    deleted_at nil
    ended_at nil
    created_at DateTime.now
  end
end
