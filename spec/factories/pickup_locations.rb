# -*- coding: utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pickup_location do
    user
    sequence(:name) {|n| "Name#{n}"}
    sequence(:address) {|n| "沖縄県宮古島市平良荷川取#{n}"}
    gmaps true
  end
end
