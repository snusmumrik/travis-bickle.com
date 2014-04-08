class DeviceToken < ActiveRecord::Base
  belongs_to :user
  attr_accessible :device_token, :user_id
end
