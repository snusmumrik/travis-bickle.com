class Ride < ActiveRecord::Base
  belongs_to :report
  attr_accessible :report_id, :ride_latitude, :ride_longitude, :ride_address, :leave_latitude, :leave_longitude, :leave_address, :fare, :passengers, :deleted_at

validates :fare, :passengers, :presence => true, :numericality => true
end
