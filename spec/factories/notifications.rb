FactoryGirl.define do
	factory :notification do
    user
    car
    sequence(:text) {|n| "notification text#{n}"}
    sent_at DateTime.now
    canceled_at false
    accepted_at false
    deleted_at nil
  end
end
