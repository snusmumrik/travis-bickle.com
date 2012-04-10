FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@test.com"
  end

  factory :user do
    email
    password "password"
    password_confirmation "password"

    # Child of :user factory, since it's in the `factory :user` block
    # factory :admin do
    #   admin true
    # end
  end
end
