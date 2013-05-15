# -*- coding: utf-8 -*-
class CarsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_index, :api_update]
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /cars
  # GET /cars.json
  def api_index
    driver = Driver.find(params[:driver_id])
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", driver.user_id]).all if driver
    respond_to do |format|
      format.json { render json: @cars }
    end
  end

  # PUT /cars/api_update
  # PUT /cars/api_update.json
  def api_update
    @car = Car.where(["id = ?", params[:car_id]]).first
    if @car
      @car.update_attributes({:device_token => params[:device_token]})

      respond_to do |format|
        if @car.save
          format.json { render json: @car }
        else
          format.json { render json: @car.errors }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{:error => "not found" } }
      end
    end
  end

  # GET /cars
  # GET /cars.json
  def index
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:car]
      @cars = @cars.name_matches params[:car][:name]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @car }
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
    @car = Car.find(params[:id])
    if params[:year] && params[:month] && params[:day]
      @reports = Report.includes(:driver).where(["car_id = ? AND date = ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)]).all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月%-d日")} 日次成績 #{@car.name}" rescue "#{params[:year]}年#{params[:month]}月#{params[:day]} 日次成績 #{@car.name}"
    elsif params[:year] && params[:month]
      @reports = Report.includes(:driver).where(["car_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月")} 月次成績 #{@car.name}" rescue "#{params[:year]}年#{params[:month]}月} 月次成績 #{@car.name}"
    else
      params[:year] = Date.today.year
      params[:month] = Date.today.month
      @reports = Report.where(["car_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月")} 月次成績 #{@car.name}" rescue "#{params[:year]}年#{params[:month]}月} 月次成績 #{@car.name}"
    end

    @mileage = 0
    @riding_mileage = 0
    @riding_count = 0
    @meter_fare_count = 0
    @passengers = 0
    @sales = 0
    @fuel_cost = 0
    @ticket = 0
    @account_receivable = 0
    @cash = 0
    @surplus_funds = 0
    @deficiency_account = 0
    @advance = 0

    sales_hash = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = 0
      end
    end

    @reports.each do |report|
      @mileage += report.mileage if report.mileage
      @riding_mileage += report.riding_mileage if report.riding_mileage
      @riding_count += report.riding_count if report.riding_count
      @meter_fare_count += report.meter_fare_count if report.meter_fare_count
      @passengers += report.passengers if report.passengers
      @sales += report.sales if report.sales
      @fuel_cost += report.fuel_cost if report.fuel_cost
      @ticket += report.ticket if report.ticket
      @account_receivable += report.account_receivable if report.account_receivable
      @cash += report.cash if report.cash
      @surplus_funds += report.surplus_funds if report.surplus_funds
      @deficiency_account += report.deficiency_account if report.deficiency_account
      @advance += report.advance if report.advance

      sales_hash[report.driver][report.date.day] += report.sales
    end

    data_hash = Hash.new do |hash, key|
      hash[key] = Array.new
    end

    sales_hash.each do |sale|
      # sale[0] => driver
      # sale[1] => sales hash
      for i in 1..Date.new(params[:year].to_i, params[:month].to_i, -1).day
        data_hash[sale[0]] << sale[1][i]
      end
    end

    @bar = LazyHighCharts::HighChart.new('column') do |f|
      data_hash.each do |data|
        f.series(:name => data[0].name, :data => data[1])
      end

      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = (1..Date.new(params[:year].to_i, params[:month].to_i, -1).day).to_a

      ## or options for column
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({:column=>{:stacking=>"normal"}})
      # f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car }
    end
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(params[:car])
    @car.user = current_user

    respond_to do |format|
      if @car.save
        format.html { redirect_to cars_path, notice: t("activerecord.models.car") + t("message.created") }
        format.json { render json: @car, status: :created, location: @car }
      else
        format.html { render action: "new" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.update_attribute("deleted_at", DateTime.now)

    respond_to do |format|
      format.html { redirect_to cars_path, notice: t("activerecord.models.car") + t("message.destroy") }
      format.json { head :ok }
    end
  end

  private
  def authenticate_owner
    @car = Car.find(params[:id])
    redirect_to cars_path if @car.user_id != current_user.id
  end
end
