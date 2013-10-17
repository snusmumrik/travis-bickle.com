class PickupLocation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :address, :deleted_at, :gmaps, :latitude, :longitude, :name

  acts_as_paranoid
  geocoded_by :address
  # paginates_per 25

  validates :name, :presence => true
end
