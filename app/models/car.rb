class Car < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :drivers, :through => :reports
  attr_accessible :uer_id, :base_fare, :deleted_at, :meter_fare, :car_model, :name, :car_type, :twitter_id, :twitter_name
end
