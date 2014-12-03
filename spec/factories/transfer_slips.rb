# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer_slip do
    report
    sequence(:debit) {|n| n}
    sequence(:credit) {|n| n}
  end
end
