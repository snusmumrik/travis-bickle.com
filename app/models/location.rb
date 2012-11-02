class Location < ActiveRecord::Base
  belongs_to :car
  attr_accessible :latitude, :longitude
end
