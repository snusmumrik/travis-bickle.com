class Ride < ActiveRecord::Base
  belongs_to :report
  attr_accessible :report_id, :ride_latitude, :ride_longitude, :ride_address, :leave_latitude, :leave_longitude, :leave_address, :fare, :passengers, :segment, :deleted_at, :started_at, :ended_at
  acts_as_paranoid

  validates :fare, :passengers, :presence => true, :numericality => true
end
