# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax_withholding do
    driver
    date Date.today
    working_days 1
    working_hours 1
    holiday_working_hours 1
    night_working_hours 1
    extra_working_hours 1
    base_salary 1
    percentage_pay 1
    holiday_pay 1
    night_pay 1
    extra_pay 1
    no_absence_pay 1
    no_accident_pay 1
    long_service_pay 1
    real_salary 1
    health_insurance 1
    nursing_insurance 1
    pension ""
    unemployment_isurance 1
    taxables 1
    dependents 1
    calculated_tax_amount 1
    adjustment 1
    net_collection 1
    resident_tax 1
    bonus 1
    social_insurance 1
  end
end
