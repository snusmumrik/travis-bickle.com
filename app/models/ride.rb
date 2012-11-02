class Ride < ActiveRecord::Base
  belongs_to :report
  attr_accessible :deleted_at, :fare, :leave_latitude, :leave_longitude, :passengers, :ride_latitude, :ride_longitude
end
