# -*- coding: utf-8 -*-
class LocationsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api_update
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # PUT /locations/api_update
  # PUT /locations/api_update.json
  def api_update
    @location = Location.where(["car_id = ?", params[:car_id]]).first || Location.new(:car_id => params[:car_id])

    @location.address = params[:address]
    @location.latitude = params[:latitude]
    @location.longitude = params[:longitude]

    respond_to do |format|
      if @location.save
        format.json { render json: @location, status: :created, location: @location }
      else
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.includes(:car => :user).where(["users.id = ?", current_user.id]).order("locations.car_id").all
    @json = @locations.to_gmaps4rails do |location, marker|
      begin
        if location.car.reports.where(["finished_at IS NULL"]).first.rides.where("leave_latitude IS NULL").first
          marker.picture({
                           :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|FF0000|12|_|#{location.car.try(:name) }",
                           :width   => 100,
                           :height  => 100
                         })
        end
      rescue Exception => e
        marker.picture({
                         :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|ADD8E6|12|_|#{location.car.try(:name) }",
                         :width   => 100,
                         :height  => 100
                       })
      end

      marker.infowindow "<img src=\"http://miyakoshinpo.com/data/upfile/607-1.jpg\" width=200 height=200><br /><a href='/notifications/new?car_id=#{location.car_id}'>#{location.car.try(:name)}へ配車指示</a>"
      marker.title location.car.try(:name)
      marker.json({:car_id => location.car.try(:id)})
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  private
  def authenticate_owner
    @location = Location.find(params[:id])
    redirect_to locations_path if @location.car.user_id != current_user.id
  end
end
