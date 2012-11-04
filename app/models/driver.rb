class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :cars, :through => :reports
  attr_accessible :birthday, :blood_type, :deleted_at, :licence_number, :name, :start_working_at
end
