class CheckPoint < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :name, :deleted_at
  acts_as_paranoid
  # paginates_per 25

  validates :user_id, :name, :presence => true

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
