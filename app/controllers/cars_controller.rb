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
    @title += "#{t('activerecord.models.car')}#{t('link.index')}"
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
      @year = params[:year].to_i
      @month = params[:month].to_i
      @day = params[:day].to_i

      @reports = Report.includes(:driver).where(["car_id = ? AND started_at = ?", params[:id], Date.new(@year, @month, @day)]).order("reports.started_at").all
      @title += " | #{@reports.first.started_at.strftime("%Y年%-m月%-d日")} 日次成績 #{@car.name}" rescue "#{@year}年#{@month}月#{@day} 日次成績 #{@car.name}"
    elsif params[:year] && params[:month]
      @year = params[:year].to_i
      @month = params[:month].to_i

      @reports = Report.includes(:driver).where(["car_id = ? AND started_at BETWEEN ? AND ?", params[:id], Date.new(@year, @month, 1), Date.new(@year, @month, -1)]).order("reports.started_at").all
      @title += " | #{@reports.first.started_at.strftime("%Y年%-m月")} 月次成績 #{@car.name}" rescue "#{@year}年#{@month}月} 月次成績 #{@car.name}"
    else
      @year = Date.today.year.to_i
      @month = Date.today.month.to_i

      @reports = Report.where(["car_id = ? AND started_at BETWEEN ? AND ?", params[:id], Date.new(@year, @month, 1), Date.new(@year, @month, -1)]).order("reports.started_at").all
      @title += " | #{@reports.first.started_at.strftime("%Y年%-m月")} 月次成績 #{@car.name}" rescue "#{@year}年#{@month}月} 月次成績 #{@car.name}"
    end

    @mileage = 0
    @riding_mileage = 0
    @riding_count = 0
    @meter_fare_count = 0
    @passengers = 0
    @sales = 0
    @extra_sales = 0
    @fuel_cost = 0
    @ticket = 0
    @account_receivable = 0
    @cash = 0
    @surplus_funds = 0
    @deficiency_account = 0
    @advance = 0

    @sales_hash = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = 0
      end
    end

    daily_sales_hash = Hash.new do |hash, key|
      hash[key] = 0
    end

    fuel_cost_hash = Hash.new do |hash, key|
      hash[key] = 0
    end

    @reports.each do |report|
      @sales_hash[report.started_at.day][:mileage] += report.mileage if report.mileage
      @sales_hash[report.started_at.day][:riding_mileage] += report.riding_mileage if report.riding_mileage
      @sales_hash[report.started_at.day][:riding_count] += report.riding_count if report.riding_count
      @sales_hash[report.started_at.day][:meter_fare_count] += report.meter_fare_count if report.meter_fare_count
      @sales_hash[report.started_at.day][:passengers] += report.passengers if report.passengers
      @sales_hash[report.started_at.day][:sales] += report.sales if report.sales
      @sales_hash[report.started_at.day][:extra_sales] += report.extra_sales if report.extra_sales
      @sales_hash[report.started_at.day][:fuel_cost] += report.fuel_cost if report.fuel_cost
      @sales_hash[report.started_at.day][:ticket] += report.ticket if report.ticket
      @sales_hash[report.started_at.day][:account_receivable] += report.account_receivable if report.account_receivable
      @sales_hash[report.started_at.day][:cash] += report.cash if report.cash
      @sales_hash[report.started_at.day][:surplus_funds] += report.surplus_funds if report.surplus_funds
      @sales_hash[report.started_at.day][:deficiency_account] += report.deficiency_account if report.deficiency_account
      @sales_hash[report.started_at.day][:advance] += report.advance if report.advance

      @mileage += report.mileage if report.mileage
      @riding_mileage += report.riding_mileage if report.riding_mileage
      @riding_count += report.riding_count if report.riding_count
      @meter_fare_count += report.meter_fare_count if report.meter_fare_count
      @passengers += report.passengers if report.passengers
      @sales += report.sales if report.sales
      @extra_sales += report.extra_sales if report.extra_sales
      @fuel_cost += report.fuel_cost if report.fuel_cost
      @ticket += report.ticket if report.ticket
      @account_receivable += report.account_receivable if report.account_receivable
      @cash += report.cash if report.cash
      @surplus_funds += report.surplus_funds if report.surplus_funds
      @deficiency_account += report.deficiency_account if report.deficiency_account
      @advance += report.advance if report.advance

      # @sales_hash[report.driver][report.started_at.day] += report.sales
      # daily_@sales_hash[report.started_at.day] += report.sales
      # fuel_cost_hash[report.started_at.day] += report.fuel_cost
    end

    sales_data_hash = Hash.new do |hash, key|
      hash[key] = 0
    end

    fuel_cost_data_hash = Hash.new do |hash, key|
      hash[key] = 0
    end

    @reports.each do |report|
      sales_data_hash[report.started_at.day] += report.sales + report.extra_sales if report.sales && report.extra_sales
      fuel_cost_data_hash[report.started_at.day] += report.fuel_cost if report.fuel_cost
    end

    sales_array = Array.new
    for i in 1..Date.new(@year, @month, -1).day
      if sales_data_hash[i] != 0
        sales_array << sales_data_hash[i]
      else
        sales_array << 0
      end
    end

    fuel_cost_array = Array.new
    for i in 1..Date.new(@year, @month, -1).day
      if @sales_hash[i]
        fuel_cost_array << @sales_hash[i][:fuel_cost]
      else
        fuel_cost_array << 0
      end
    end

    fuel_cost_rates = Array.new
    for i in 1..Date.new(@year, @month, -1).day
      if sales_data_hash[i] != 0
        fuel_cost_rates << (fuel_cost_data_hash[i].to_f / sales_data_hash[i] * 100).ceil
      else
        fuel_cost_rates << 0
      end
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = (1..Date.new(@year, @month, -1).day).to_a
      f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:type => "column", :name => t("activerecord.attributes.report.sales") + "+" + t("activerecord.attributes.report.extra_sales"), :yAxis => 0, :data => sales_array, :tooltip => {:valueSuffix => "円"})
      f.series(:type => "column", :name => t("activerecord.attributes.report.fuel_cost"), :yAxis => 0, :data => fuel_cost_array, :tooltip => {:valueSuffix => "円"})
      f.series(:type => "spline", :name => t("views.report.fuel_cost_rate"), :yAxis => 1, :data => fuel_cost_rates, :tooltip => {:valueSuffix => "%"})

      f.yAxis [
               {:title => {:text => t("activerecord.attributes.report.sales") + "・" + t("activerecord.attributes.report.fuel_cost"), :margin => 70} },
               {:title => {:text => t("views.report.fuel_cost_rate")}, :opposite => true},
              ]
    end

    respond_to do |format|
      if params[:year] && params[:month]
        format.html # show.html.erb
      else
        format.html {redirect_to "#{car_path(@car)}/#{@year}/#{@month}"}
      end
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

  # PUT /cars/1
  # PUT /cars/1.json
  def update
    @car = Car.find(params[:id])

    respond_to do |format|
      if @car.update_attributes(params[:car])
      format.html { redirect_to cars_path, notice: t("activerecord.models.car") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
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
