class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => :show

  # GET /documents
  # GET /documents.json
  def index
    @driver = Driver.find(params[:driver_id])
    if params[:year] && params[:month]
      @reports = Report.where(["driver_id = ? AND date BETWEEN ? AND ?", params[:driver_id], Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).order("date").all
    else
      params[:year] = Date.today.year
      params[:month] = Date.today.month
      @reports = Report.where(["driver_id = ? AND date BETWEEN ? AND ?", params[:driver_id], Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
    end

    @working_hours = 0
    @rest_hours = 0
    @rest_hash = {}
    @late_night_hash = {}
    @late_night = 0
    @sales = 0

    @reports.each do |report|
      rest_time = 0
      report.rests.each do |rest|
        rest_time += rest.ended_at - rest.started_at
      end
      @working_hours += report.finished_at - report.started_at if report.finished_at
      @rest_hours += rest_time
      hours = rest_time.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.id, [hours[0], mins[0]])

      @sales += report.sales if report.sales

      if report.finished_at.nil?
        return
      elsif report.finished_at.hour == 22 || report.finished_at.hour == 23
        @late_night_hash.store(report.id, 1)
        @late_night += 1
      elsif report.finished_at.hour == 0 || report.finished_at.hour == 1
        @late_night_hash.store(report.id, 2)
        @late_night += 2
      elsif report.finished_at.hour == 2
        @late_night_hash.store(report.id, 3)
        @late_night += 3
      elsif report.finished_at.hour >= 3 && report.finished_at.hour < 11
        @late_night_hash.store(report.id, 4)
        @late_night += 4
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /documents/reports/1
  # GET /documents/reports/1.json
  def show
    @report = Report.find(params[:report_id])
    @estimated_rest = 0

    @report.rests.each do |rest|
      @estimated_rest += rest.ended_at - rest.started_at
    end
    hours = @estimated_rest.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @estimated_rest = [hours[0], mins[0]]

    @meter = Meter.includes(:report).where(["reports.car_id = ?", @report.car_id]).order("meters.created_at DESC").offset(1).first
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
