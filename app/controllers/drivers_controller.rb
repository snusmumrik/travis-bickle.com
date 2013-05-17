# -*- coding: utf-8 -*-
class DriversController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api_signin
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /drivers
  # GET /drivers.json
  def api_signin
    respond_to do |format|
      @driver = Driver.where(["email = ? AND deleted_at IS NULL", params[:email]]).first
      if @driver && @driver.authenticate(params[:password])
        format.json { render json: @driver }
      else
        format.json { render json:{:error => "signin failed" } }
      end
    end
  end

  # GET /drivers
  # GET /drivers.json
  def index
    @title += " | #{t('activerecord.models.driver')}#{t('link.index')}"
    @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:driver]
      @drivers = @drivers.name_matches params[:driver][:name]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @driver }
    end
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
    @driver = Driver.find(params[:id])
    if params[:year] && params[:month] && params[:day]
      @reports = Report.includes(:car, :rests).where(["driver_id = ? AND date = ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)]).all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月%-d日")} 日次成績 #{@driver.name}" rescue "#{params[:year]}年#{params[:month]}月#{params[:day]} 日次成績 #{@driver.name}"
    elsif params[:year] && params[:month]
      @reports = Report.includes(:car, :rests).where(["driver_id = ? AND date BETWEEN ? AND ? AND deleted_at IS NULL", params[:id], Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).order("date").all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月")} 月次成績 #{@driver.name}" rescue "#{params[:year]}年#{params[:month]}月 月次成績 #{@driver.name}"
      @sales_hash = Hash.new do |hash, key|
        hash[key] = Hash.new do |hash, key|
          hash[key] = 0
        end
      end
    else
      params[:year] = Date.today.year
      params[:month] = Date.today.month
      @reports = Report.includes(:car, :rests).where(["driver_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
      @title += " | #{params[:year]}年#{params[:month]}月 月次成績 #{@driver.name}"
    end

    @working_hours = 0
    @rest_hours = 0
    @rest_hash = {}

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

    @reports.each do |report|
      if @sales_hash
        @sales_hash[report.date.day][:id] = report.id
        @sales_hash[report.date.day][:car] = report.car
        @sales_hash[report.date.day][:mileage] += report.mileage if report.mileage
        @sales_hash[report.date.day][:riding_mileage] += report.riding_mileage if report.riding_mileage
        @sales_hash[report.date.day][:riding_count] += report.riding_count if report.riding_count
        @sales_hash[report.date.day][:meter_fare_count] += report.meter_fare_count if report.meter_fare_count
        @sales_hash[report.date.day][:passengers] += report.passengers if report.passengers
        @sales_hash[report.date.day][:sales] += report.sales if report.sales
        @sales_hash[report.date.day][:fuel_cost] += report.fuel_cost if report.fuel_cost
        @sales_hash[report.date.day][:ticket] += report.ticket if report.ticket
        @sales_hash[report.date.day][:account_receivable] += report.account_receivable if report.account_receivable
        @sales_hash[report.date.day][:cash] += report.cash if report.cash
        @sales_hash[report.date.day][:surplus_funds] += report.surplus_funds if report.surplus_funds
        @sales_hash[report.date.day][:deficiency_account] += report.deficiency_account if report.deficiency_account
        @sales_hash[report.date.day][:advance] += report.advance if report.advance
        @sales_hash[report.date.day][:started_at] = report.started_at
        @sales_hash[report.date.day][:finished_at] = report.finished_at
      end

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

      rest_time = 0
      report.rests.each do |rest|
        rest_time += rest.ended_at - rest.started_at
      end
      @working_hours += report.finished_at - report.started_at if report.finished_at
      @rest_hours += rest_time
      hours = rest_time.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.date.day, [hours[0], mins[0]])
    end

    if @sales_hash
      sales_array = Array.new
      for i in 1..Date.new(params[:year].to_i, params[:month].to_i, -1).day
        if @sales_hash[i]
          sales_array << @sales_hash[i][:sales]
        else
          sales_array << 0
        end
      end
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = (1..Date.new(params[:year].to_i, params[:month].to_i, -1).day).to_a
      # f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:type => 'column', :name => t("activerecord.attributes.report.sales"), :data => sales_array)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @driver }
    end
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(params[:driver])
    @driver.user = current_user

    respond_to do |format|
      if @driver.save
        format.html { redirect_to drivers_path, notice: t("activerecord.models.driver") + t("message.created") }
        format.json { render json: @driver, status: :created, location: @driver }
      else
        format.html { render action: "new" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.update_attribute("deleted_at", DateTime.now)

    respond_to do |format|
      format.html { redirect_to drivers_path, notice: t("activerecord.models.driver") + t("message.destroy") }
      format.json { head :ok }
    end
  end

  private
  def authenticate_owner
    @driver = Driver.find(params[:id])
    redirect_to drivers_path if @driver.user_id != current_user.id
  end
end
