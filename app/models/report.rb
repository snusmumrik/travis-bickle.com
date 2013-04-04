class Report < ActiveRecord::Base
  belongs_to :driver
  belongs_to :car
  has_many :rides
  has_many :rests

  attr_accessible :driver_id, :car_id, :date, :account_receivable, :advance, :cash, :deficiency_account, :deleted_at, :fuel_cost, :meter_fare_count, :mileage, :passengers, :riding_count, :riding_mileage, :riding_rate, :sales, :sales_par_kilometer, :surplus_funds, :ticket, :meter, :started_at, :finished_at
  acts_as_paranoid

  validates :car_id, :driver_id, :presence => true
end
