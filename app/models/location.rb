class Location < ActiveRecord::Base
  belongs_to :car
  attr_accessible :car_id, :address, :gmaps, :latitude, :longitude

  acts_as_gmappable

  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.address}"
  end

  # def gmaps4rails_infowindow
  #   "<img src=\"http://maruchiku.jp/images/img_cars02.jpg\"> #{self.car.name}"
  # end

  # def gmaps4rails_title
  #   # add here whatever text you desire
  # end

  # def gmaps4rails_marker_picture
  #   {
  #     "picture" => ,          # string,  mandatory
  #     "width" =>  ,          # integer, mandatory
  #     "height" => ,          # integer, mandatory
  #     "marker_anchor" => ,   # array,   facultative
  #     "shadow_picture" => ,  # string,  facultative
  #     "shadow_width" => ,    # string,  facultative
  #     "shadow_height" => ,   # string,  facultative
  #     "shadow_anchor" => ,   # string,  facultative
  #     "rich_marker" =>   ,   # html, facultative
  #     # If used, all other attributes skipped except "marker_anchor". This array is used as follows:
  #     # [ anchor , flat ] : flat is a boolean, anchor is an int. 
  #     # See doc here: http://google-maps-utility-library-v3.googlecode.com/svn/trunk/richmarker/docs/reference.html 
  #   }
  # end
end
