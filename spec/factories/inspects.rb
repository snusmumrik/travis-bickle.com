# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inspect do
    car
    date Date.today
    sequence(:span) {|n| n}
    deleted_at nil
  end
end
