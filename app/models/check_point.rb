class CheckPoint < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :name, :deleted_at
  acts_as_paranoid

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
