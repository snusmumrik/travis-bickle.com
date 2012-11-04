class Report < ActiveRecord::Base
  belongs_to :driver
  belongs_to :car
  attr_accessible :driver_id, :car_id, :account_receivable, :advance, :cash, :deficiency_account, :deleted_at, :fuel_cost, :meter_fare_count, :mileage, :passengers, :riding_count, :riding_mileage, :riding_rate, :sales, :sales_par_kilometer, :surplus_funds, :ticket
end
