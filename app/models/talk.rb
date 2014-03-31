class Talk < ActiveRecord::Base
  attr_accessible :audio, :received, :receiver_car_id, :receiver_user_id, :sender_car_id, :sender_user_id
  has_attached_file :audio,
  :url => "/assets/:class/:id/:style/:basename.:extension",
  :path => ":rails_root/app/assets/:attachment/:class/:id/:style/:basename.:extension"
end
