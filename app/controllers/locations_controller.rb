# -*- coding: utf-8 -*-
class LocationsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @title += "#{t('activerecord.models.location')}#{t('link.index')}"

    @pickup_location_option = [["迎車場所を選択", ""]]
    pickup_locations = current_user.pickup_locations.order("name")
    pickup_locations.each do |pickup_location|
      @pickup_location_option << [pickup_location.name, pickup_location.address]
    end

    if params[:location] && !params[:location][:address].blank?
      @pickup_location = params[:location][:pickup_location]
      @address = params[:location][:address]
      # @locations = Location.includes(:car => [:user, :reports => [:rides, :rests]]).near(params[:location][:address])
      @locations = Location.where(["cars.user_id = ? AND reports.finished_at IS NULL AND reports.deleted_at IS NULL",
                                   current_user.id
                                  ]).near(params[:location][:address]).joins(:car => :reports).group(:id)
    else
      @locations = Location.includes(:car => :reports).where(["cars.user_id = ? AND reports.finished_at IS NULL AND reports.deleted_at IS NULL",
                                                              current_user.id
                                                             ]).order("cars.name").all
    end

    @json = @locations.to_gmaps4rails do |location, marker|
      begin
        if !location.car.reports.blank? && !location.car.reports.where("finished_at IS NULL").order("started_at").last.rides.blank? && location.car.reports.where("finished_at IS NULL").order("started_at").last.rides.last.ended_at.nil?
          marker.picture({
                           :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|FF0000|12|_|#{location.car.try(:name) }",
                           :width   => 100,
                           :height  => 100
                         })
        elsif !location.car.reports.blank? && !location.car.reports.where("finished_at IS NULL").order("started_at").last.rests.blank? && location.car.reports.where("finished_at IS NULL").order("started_at").last.rests.last.ended_at.nil?
          marker.picture({
                           :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|90ee90|12|_|#{location.car.try(:name) }",
                           :width   => 100,
                           :height  => 100
                         })
        else
          marker.picture({
                           :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|ADD8E6|12|_|#{location.car.try(:name) }",
                           :width   => 100,
                           :height  => 100
                         })
        end
        marker.infowindow "<img src=\"http://static.tumblr.com/gw0wbvo/y2Emn54fm/cars_photo02.png\" width=200 height=200><br />
現在地：#{location.address}<br />
#{location.updated_at.strftime("%Y/%m/%d %H:%M:%S") rescue nil} 更新<br />
<a href='/notifications/new?car_id=#{location.car_id}'>#{location.car.name}へ配車指示</a><br />
<a href=\"/reports/#{location.car.reports.last.id}\">乗務記録</a>"
        marker.title location.car.try(:name)
        marker.json({:car_id => location.car.try(:id)})
      rescue Exception => e
        marker.picture({
                         :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|FFFFFF|12|_|#{location.car.try(:name) }",
                         :width   => 100,
                         :height  => 100
                       })
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @json }
    end
  end

  private
  def authenticate_owner
    @location = Location.find(params[:id])
    redirect_to locations_path if @location.car.user_id != current_user.id
  end
end
