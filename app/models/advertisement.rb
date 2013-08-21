class Advertisement < ActiveRecord::Base
  attr_accessible :deleted_at, :name, :youtube_videoid, :location, :latitude, :longitude, :gmaps
  acts_as_paranoid
  acts_as_gmappable

  has_many :images, :as => :parent, :dependent => :destroy

  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.location}"
  end
end
