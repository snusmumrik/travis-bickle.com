# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :check_point do
    user
    sequence(:name){|n| "check_point#{n}"}
    deleted_at nil
  end
end
