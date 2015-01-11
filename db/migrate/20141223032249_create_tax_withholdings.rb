class CreateTaxWithholdings < ActiveRecord::Migration
  def change
    create_table :tax_withholdings do |t|
      t.references :driver
      t.date :date
      t.integer :working_days
      t.integer :working_hours
      t.integer :holiday_working_hours
      t.integer :night_working_hours
      t.integer :extra_working_hours
      t.integer :base_salary
      t.integer :percentage_pay
      t.integer :holiday_pay
      t.integer :night_pay
      t.integer :extra_pay
      t.integer :no_absence_pay
      t.integer :no_accident_pay
      t.integer :long_service_pay
      t.integer :real_salary
      t.integer :health_insurance
      t.integer :nursing_insurance
      t.integer :pension
      t.integer :unemployment_insurance
      t.integer :taxables
      t.integer :dependents
      t.integer :calculated_tax_amount
      t.integer :adjustment
      t.integer :net_collection
      t.integer :resident_tax
      t.integer :bonus
      t.integer :social_insurance

      t.timestamps
    end
  end
end
