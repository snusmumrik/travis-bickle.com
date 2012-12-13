class Car < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :drivers, :through => :reports
  attr_accessible :user_id, :base_fare, :deleted_at, :meter_fare, :car_model, :name, :car_type, :twitter_id, :twitter_name

  validates :name, :base_fare, :meter_fare, :twitter_id, :presence => true
end
