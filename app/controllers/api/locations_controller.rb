# -*- coding: utf-8 -*-
class Api::LocationsController < ApplicationController
  before_filter :authenticate_devise, :only => :index
  before_filter :authenticate_token, :only => :update
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # called from call travis
  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.includes(:car => :user).near([params[:latitude], params[:longitude]], 10)
    @cars = Hash.new
    @users = Hash.new
    @locations.each do |location|
      @cars.store(location.id, location.car)
      @users.store(location.id, location.car.user)
    end

    respond_to do |format|
      format.json { render json: {:locations => @locations, :cars => @cars, :users => @users} }
    end
  end

  # PUT /api/locations/1
  # PUT /api/locations/1.json
  def update
    @location = Location.where(["car_id = ?", @car.id]).first || Location.new(:car_id => @car.id)

    @location.address = params[:address]
    @location.latitude = params[:latitude]
    @location.longitude = params[:longitude]

    respond_to do |format|
      if @location.save
        format.json { render json: @location }
      else
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_devise
    render json:{ :error => "Not Acceptable:locations#index", :status => 406 } unless params[:latitude] && params[:longitude] # && params[:device_token]
  end

  def authenticate_token
    # params[:id] == car_id  !!caution!!
    @car = Car.where(["id = ? AND device_token = ? AND deleted_at IS NULL", params[:id], params[:device_token]]).first
    render json:{ :error => "Not Acceptable:locations#update", :status => 406 } unless @car
  end
end
