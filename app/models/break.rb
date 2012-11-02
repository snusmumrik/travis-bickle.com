class Break < ActiveRecord::Base
  belongs_to :report
  attr_accessible :deleted_at, :ended_at, :latitude, :longitude
end
