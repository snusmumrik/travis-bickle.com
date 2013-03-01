class Rest < ActiveRecord::Base
  belongs_to :report
  attr_accessible :report_id, :deleted_at, :ended_at, :latitude, :location, :longitude, :address, :started_at
end
