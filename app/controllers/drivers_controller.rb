# -*- coding: utf-8 -*-
class DriversController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]

  # GET /drivers
  # GET /drivers.json
  def index
    @title += " | #{t('activerecord.models.driver')}#{t('link.index')}"
    if params[:driver]
      @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL AND (name LIKE ? OR email LIKE ?)",
                               current_user.id,
                               "%#{params[:driver][:name]}%",
                               "%#{params[:driver][:name]}%"
                              ]).order("name")
    else
      @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL", current_user.id]).order("name").page params[:page]
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

    params[:year] = Date.today.year unless params[:year]
    params[:month] = Date.today.month unless params[:month]

    if params[:day]
      @reports = Report.includes(:car, :rests).where(["driver_id = ? AND started_at BETWEEN ? AND ?",
                                                      params[:id],
                                                      Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]} 00:00}"),
                                                      Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]} 23:59}")]).order("reports.started_at").all
      @title += " | #{params[:year]}年#{params[:month]}月#{params[:day]} 日次成績 #{@driver.name}"
    else
      end_of_month = Date.new(params[:year].to_i, params[:month].to_i, -1).day
      @reports = Report.includes(:car, :rests).where(["driver_id = ? AND started_at BETWEEN ? AND ? AND deleted_at IS NULL",
                                                      params[:id],
                                                      Time.zone.parse("#{params[:year]}-#{params[:month]}-01} 00:00}"),
                                                      Time.zone.parse("#{params[:year]}-#{params[:month]}-#{end_of_month} 23:59}")]).order("reports.started_at").all
      @title += " | #{params[:year]}年#{params[:month]}月 月次成績 #{@driver.name}"
    end

    @sales_hash = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = 0
      end
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
    @extra_sales = 0
    @fuel_cost = 0
    @ticket = 0
    @account_receivable = 0
    @cash = 0
    @surplus_funds = 0
    @deficiency_account = 0
    @advance = 0

    @reports.each do |report|
      if @sales_hash
        @sales_hash[report.started_at.day][:id] = report.id
        @sales_hash[report.started_at.day][:car] = report.car
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
        @sales_hash[report.started_at.day][:started_at] = report.started_at
        @sales_hash[report.started_at.day][:finished_at] = report.finished_at
      end

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

      rest_time = 0
      report.rests.each do |rest|
        rest_time += rest.ended_at - rest.started_at if rest.ended_at && rest.started_at
      end
      @working_hours += report.finished_at - report.started_at if report.finished_at
      @rest_hours += rest_time
      hours = rest_time.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.started_at.day, [hours[0], mins[0]])
    end

    if @sales_hash
      sales_array = Array.new
      for i in 1..Date.new(params[:year].to_i, params[:month].to_i, -1).day
        if @sales_hash[i]
          sales_array << @sales_hash[i][:sales] + @sales_hash[i][:extra_sales]
        else
          sales_array << 0
        end
      end
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = (1..Date.new(params[:year].to_i, params[:month].to_i, -1).day).to_a
      # f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:type => 'column', :name => t("activerecord.attributes.report.sales") + "+" + t("activerecord.attributes.report.extra_sales"), :data => sales_array)
    end

    respond_to do |format|
      if params[:year] && params[:month]
        format.html # show.html.erb
      else
        format.html {redirect_to "#{driver_path(@driver)}/#{params[:year]}/#{params[:month]}"}
      end
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

  # PUT /drivers/1
  # PUT /drivers/1.json
  def update
    @driver = Driver.find(params[:id])

    respond_to do |format|
      if @driver.update_attributes(params[:driver])
      format.html { redirect_to drivers_path, notice: t("activerecord.models.driver") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
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
