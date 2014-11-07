class MinimumWage < ActiveRecord::Base
  belongs_to :user
  attr_accessible :price, :user_id
  acts_as_paranoid
end
