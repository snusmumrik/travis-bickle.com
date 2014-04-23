class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :reports
  has_many :cars, :through => :reports
  has_secure_password

  attr_accessible :user_id, :name, :email, :password, :password_confirmation, :device_token, :deleted_at

  # if use this, deleted drivers's reports cannot be shown
  # acts_as_paranoid
  # paginates_per 25

  validates :user_id, :name, :email, :presence => true
  validates :password, :password_confirmation, :presence => true, :length => { :within => 6..40 }, :on => :update, :unless => lambda{ |driver| driver.password.blank? }
  validates :email, :uniqueness => true
end
