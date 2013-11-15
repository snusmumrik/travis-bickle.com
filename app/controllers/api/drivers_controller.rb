class Api::DriversController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /api/drivers/signin
  # POST /api/drivers/signin.json
  def signin
    respond_to do |format|
      @driver = Driver.where(["email = ? AND deleted_at IS NULL", params[:email]]).first
      if @driver && @driver.authenticate(params[:password])
        format.json { render json: @driver }
      else
        format.json { render json:{:error => "signin failed" } }
      end
    end
  end

  # GET /api/drivers
  # GET /api/drivers.json
  def index
    driver = Driver.find(params[:driver_id])
    @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL", driver.user_id]).all if driver

    respond_to do |format|
      if @drivers
        format.json { render json: @drivers }
      else
        format.json { render json:{ :error => "Not Acceptable:drivers#index", :status => 406 } }
      end
    end
  end
end