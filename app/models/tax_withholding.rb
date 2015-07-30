class TaxWithholding < ActiveRecord::Base
  belongs_to :driver

  attr_accessible :adjustment, :base_salary, :bonus, :calculated_tax_amount, :date, :dependents, :driver_id, :extra_pay, :extra_working_hours, :health_insurance, :holiday_pay, :holiday_working_hours, :long_service_pay, :net_collection, :night_pay, :night_working_hours, :no_absence_pay, :no_accident_pay, :nursing_insurance, :pension, :percentage_pay, :real_salary, :resident_tax, :social_insurance, :taxables, :unemployment_insurance, :working_days, :working_hours

  validates :base_salary, :percentage_pay, :holiday_pay, :night_pay, :extra_pay, :no_absence_pay, :no_accident_pay, :long_service_pay, :real_salary, :health_insurance, :nursing_insurance, :pension, :unemployment_insurance, presence: true
end
