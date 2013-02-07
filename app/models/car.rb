class Car < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :drivers, :through => :reports
  attr_accessible :user_id, :name, :base_fare, :meter_fare, :deleted_at

  validates :name, :base_fare, :meter_fare, :presence => true

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
