class CheckPoint < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :name, :deleted_at
end
