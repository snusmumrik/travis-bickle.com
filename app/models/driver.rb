class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :cars, :through => :reports
  has_secure_password

  attr_accessible :user_id, :name, :email, :password, :deleted_at

  validates :user_id, :name, :email, :password, :presence => true
  validates :email, :uniqueness => true

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
