# -*- coding: utf-8 -*-
class LocationsController < InheritedResources::Base

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.includes(:car => :user).where(["users.id = ?", current_user.id]).all
    @json = Location.all.to_gmaps4rails do |location, marker|
      marker.picture({
                  :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|FFB573|12|_|#{location.car.name}",
                  :width   => 100,
                  :height  => 100
                 })
      marker.infowindow "<img src=\"http://maruchiku.jp/images/img_cars02.jpg\"><br />#{location.car.name}"
      marker.title location.car.name
      marker.json({:car_id => location.car.id, :foo => "bar" })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @location }
    end
  end
end
