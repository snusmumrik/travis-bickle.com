# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :check_point_status do
    report nil
    check_point nil
    status "MyString"
  end
end
