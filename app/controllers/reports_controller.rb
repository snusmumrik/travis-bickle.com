# -*- coding: utf-8 -*-
class ReportsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_create, :api_update]
  before_filter :get_drivers_option, :except => [:index, :show]

  # POST /reports/api_create
  # POST /reports/api_create.jsonb
  def api_create
    @report = Report.where(["car_id = ? AND driver_id = ? AND mileage IS NULL", params[:car_id], params[:driver_id]]).first
    if @report
      @report.update_attribute(:updated_at, Time.now())
      respond_to do |format|
        format.json { render json: @report }
      end
    else
      @report = Report.new(:car_id => params[:car_id], :driver_id => params[:driver_id])
      respond_to do |format|
        if @report.save
          format.json { render json: @report, status: :created, location: @report }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /reports/api_update
  # PUT /reports/api_update.json
  def api_update
    @report = Report.where(["car_id = ? AND driver_id = ? AND mileage IS NULL", params[:car_id], params[:driver_id]]).first
    if @report
      @report.meter = params[:meter]
      @report.mileage = params[:mileage]
      @report.riding_mileage = params[:riding_mileage]
      @report.riding_count = params[:riding_count]
      @report.meter_fare_count = params[:meter_fare_count]

      passengers = 0
      sales = 0
      begin
        rides = Ride.where(["report_id = ?", @report.id]).all
        rides.each do |ride|
          passengers += ride.passengers
          sales += ride.fare
        end
      rescue
      end
      @report.passengers = passengers
      @report.sales = sales

      respond_to do |format|
        if @report.save
          format.json { render json: @report, status: :created, location: @report }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{:error => "not found" } }
      end
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Check Point was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def get_drivers_option
    @drivers_option = [[]]
    drivers = Driver.where("deleted_at is NULL").all
    drivers.each do |driver|
      @drivers_option << [driver.name, driver.id]
    end
  end
end
