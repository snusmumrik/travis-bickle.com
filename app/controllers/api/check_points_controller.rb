class Api::CheckPointsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /api/check_points
  # GET /api/check_points.json
  def index
    @car = Car.where(["device_token = ? AND deleted_at IS NULL", params[:device_token]]).order("updated_at DESC").first
    @check_points = CheckPoint.where(["user_id = ?", @car.user_id]).all
    respond_to do |format|
      if @check_points
        format.json { render json: @check_points }
      else
        format.json { render json:{ :error => "Not Acceptable:check_points#index", :status => 406 } }
      end
    end
  end
end
