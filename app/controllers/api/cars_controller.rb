class Api::CarsController < ApplicationController
  before_filter :authenticate_token
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /api/cars
  # GET /api/cars.json
  def index
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", @driver.user_id]).order("name").all

    respond_to do |format|
      if @cars
        format.json { render json: @cars }
      else
        format.json { render json:{ :error => "Not Acceptable:cars#index", :status => 406 } }
      end
    end
  end

  private
  def authenticate_token
    @driver = Driver.where(["device_token = ?", params[:device_token]]).first
    render json:{ :error => "Not Acceptable:drivers#authenticate_token", :status => 406 } unless @driver
  end
end
