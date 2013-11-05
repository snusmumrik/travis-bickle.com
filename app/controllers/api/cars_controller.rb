class Api::CarsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /api/cars
  # GET /api/cars.json
  def index
    @cars = Car.where(["device_token = ? AND deleted_at IS NULL", params[:device_token]]).all

    respond_to do |format|
      if @cars
        format.json { render json: @cars }
      else
        format.json { render json:{ :error => "Not Acceptable:cars#index", :status => 406 } }
      end
    end
  end
end
