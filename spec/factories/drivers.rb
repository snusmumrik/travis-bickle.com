# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    user
    sequence(:tc_user_id) {|n| "tc_user_id#{n}"}
    sequence(:name) {|n| "name#{n}"}
    sequence(:email) {|n| "email#{n}@test.com"}
    password "password"
    password_confirmation "password"
    password_digest "password"
    deleted_at nil
  end
end
