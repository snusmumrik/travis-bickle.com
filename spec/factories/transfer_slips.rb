# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer_slip do
    report
    debit "MyString"
    sequence(:debit) {|n| n}
    credit "MyString"
    sequence(:credit) {|n| n}
  end
end
