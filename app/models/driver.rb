class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :cars, :through => :reports
  attr_accessible :user_id, :birthday, :blood_type, :deleted_at, :licence_number, :name, :start_working_at

  validates :name, :presence => true

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
