FactoryGirl.define do
  # sequence :email do |n|
  #   "email#{n}@test.com"
  # end

  factory :user do
    sequence(:email) {|n| "email#{n}@example.com"}
    sequence(:username) {|n| "username#{n}"}
    password "password"
    password_confirmation "password"

    # Child of :user factory, since it's in the `factory :user` block
    # factory :admin do
    #   admin true
    # end

    factory :user_with_associates do
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to them
      after(:create) do |user|
        FactoryGirl.create_list(:car_with_location, 3, user: user)
        FactoryGirl.create_list(:driver_with_report, 3, user: user)
        FactoryGirl.create_list(:check_point, 3, user: user)
      end
    end
  end
end
