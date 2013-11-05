class Api::LocationsController < ApplicationController
  before_filter :authenticate_token
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

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
  def authenticate_token
    # params[:id] == car_id  !!caution!!
    @car = Car.where(["id = ? AND device_token = ? AND deleted_at IS NULL", params[:id], params[:device_token]]).first
    render json:{ :error => "Not Acceptable:locations#update", :status => 406 } unless @car
  end
end
