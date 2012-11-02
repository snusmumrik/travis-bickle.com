class CheckPoint < ActiveRecord::Base
  belongs_to :user
  attr_accessible :deleted_at, :name
end
