class Report < ActiveRecord::Base
  belongs_to :driver
  belongs_to :car
  has_one :meter, :dependent => :destroy
  has_many :rides, :dependent => :destroy
  has_many :rests, :dependent => :destroy
  has_many :check_point_statuses
  has_many :transfer_slips

  attr_accessible :driver_id, :car_id, :account_receivable, :advance, :cash, :deficiency_account, :deleted_at, :edy, :fuel_cost, :meter_fare_count, :mileage, :passengers, :riding_count, :riding_mileage, :sales, :extra_sales, :surplus_funds, :ticket, :started_at, :finished_at
  acts_as_paranoid

  validates :car_id, :driver_id, :presence => true

  def last_meter
    Meter.includes(:report).where(["reports.car_id = ? AND reports.started_at < ? AND reports.deleted_at IS NULL AND meters.deleted_at IS NULL", self.car_id, self.started_at]).order("reports.started_at").last || Meter.new(:meter => 0, :mileage => 0, :riding_mileage => 0, :riding_count => 0, :meter_fare_count => 0)
  end
end
