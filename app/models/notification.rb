class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :car
  attr_accessible :user_id, :car_id, :deleted_at, :read, :cancel, :text

  validates :user_id, :car_id, :text, :presence => true

  scope :name_matches, lambda {|q|
    where "text like :q", :q => "%#{q}%"
  }
end
