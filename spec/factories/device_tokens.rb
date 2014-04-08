# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_token do
    user nil
    device_token "MyString"
    deleted_at "2014-04-06 14:16:21"
  end
end
