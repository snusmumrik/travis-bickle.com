class CheckPoint < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :name, :deleted_at

  scope :name_matches, lambda {|q|
    where "name like :q", :q => "%#{q}%"
  }
end
