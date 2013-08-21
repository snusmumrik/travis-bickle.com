class Image < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  has_attached_file :image,
  :styles => { :ipad_mini_retina => "2048x1496", :ipad_mini => "1024x798", :large => "512x399", :medium => "205x150>", :thumb => "100x100>" },
  :url => "/assets/:class/:id/:style/:basename.:extension",
  :path => ":rails_root/app/assets/:attachment/:class/:id/:style/:basename.:extension"
end
