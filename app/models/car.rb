class Car < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :drivers, :through => :reports
  attr_accessible :base_fare, :deleted_at, :meter_fare, :car_model, :name, :car_type
end
