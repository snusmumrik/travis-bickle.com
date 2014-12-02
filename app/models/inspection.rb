class Inspection < ActiveRecord::Base
  belongs_to :car
  attr_accessible :car_id, :date, :span
  acts_as_paranoid

  validates :span, :presence => true
end
