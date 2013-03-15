# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rest do
    report
    location "MyString"
    latitude 1.5
    longitude 1.5
    address "MyString"
    started_at "2013-03-12 11:26:00"
    ended_at "2013-03-12 11:26:00"
    deleted_at nil
  end
end
