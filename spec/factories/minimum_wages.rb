# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :minimum_wage do
    user
    sequence(:price) {|n| n}
    deleted_at nil
  end
end
