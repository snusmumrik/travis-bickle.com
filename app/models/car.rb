class Car < ActiveRecord::Base
  belongs_to :user
  attr_accessible :base_fare, :deleted_at, :meter_fare, :model, :name, :type
end
