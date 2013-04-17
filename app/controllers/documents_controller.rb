class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_owner

  # GET /documents
  # GET /documents.json
  def index
    # @report = Report.find(params[:report_id])
    @estimated_rest = 0

    @report.rests.each do |rest|
      @estimated_rest += rest.ended_at - rest.started_at
    end
    hours = @estimated_rest.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @estimated_rest = [hours[0], mins[0]]

    @meter = Meter.includes(:report).where(["reports.car_id = ?", @report.car_id]).order("meters.created_at DESC").first
    @check_points = CheckPoint.where(["user_id = ? AND deleted_at IS NULL", current_user.id]).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report }
    end
  end

  private
  def authenticate_owner
    @report = Report.find(params[:report_id])
    redirect_to reports_path if @report.car.user_id != current_user.id
  end
end
