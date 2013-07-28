class Meter < ActiveRecord::Base
  belongs_to :report
  attr_accessible :report_id, :meter, :meter_fare_count, :mileage, :riding_count, :riding_mileage, :deleted_at
  acts_as_paranoid
end
