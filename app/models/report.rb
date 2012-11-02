class Report < ActiveRecord::Base
  belongs_to :driver
  attr_accessible :account_receivable, :advance, :cash, :deficiency_account, :deleted_at, :fuel_cost, :meter_fare_count, :mileage, :passengers, :riding_count, :riding_mileage, :riding_rate, :sales, :sales_par_kilometer, :surplus_funds, :ticket
end
