# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    sender_user_id 1
    sender_car_id 1
    receiver_user_id 1
    receiver_car_id 1
    received false
  end
end
