class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :car
  attr_accessible :user_id, :car_id, :deleted_at, :accepted_at, :canceled_at, :sent_at, :text

  acts_as_paranoid
  # paginates_per 25

  validates :user_id, :car_id, :text, :presence => true
end
