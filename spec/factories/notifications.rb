FactoryGirl.define do
	factory :notification do
    user
    car
    sequence(:text) {|n| "notification text#{n}"}
    read false
    deleted_at nil
  end
end
