class CheckPointStatus < ActiveRecord::Base
  belongs_to :report
  belongs_to :check_point
  attr_accessible :status

  attr_accessible :report_id, :check_point_id, :status
  
  acts_as_paranoid
end
