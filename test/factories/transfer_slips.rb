# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer_slip do
    report nil
    debit "MyString"
    debit_amount 1
    credit "MyString"
    credit_amount 1
  end
end
