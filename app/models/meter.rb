class Meter < ActiveRecord::Base
  belongs_to :car
  attr_accessible :meter, :meter_fare_count, :mileage, :riding_count, :riding_mileage
end
