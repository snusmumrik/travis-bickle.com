# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inspection do
    car nil
    date "2014-12-02"
    span 1
  end
end
