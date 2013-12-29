class Car < ActiveRecord::Base
  belongs_to :user
  has_one :location
  has_many :reports
  has_many :drivers, :through => :reports

  attr_accessible :user_id, :name, :base_fare, :meter_fare, :meter_fare_segment, :initial_meter, :access_token, :device_token, :deleted_at, :updated_at

  # if use this, deleted car's reports cannot be shown
  # acts_as_paranoid
  # paginates_per 25

  validates :user_id, :name, :base_fare, :meter_fare, :presence => true

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
