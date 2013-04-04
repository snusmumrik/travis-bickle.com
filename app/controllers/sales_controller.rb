class SalesController < ApplicationController
  # GET /sales
  # GET /sales.json
  def index
    if params[:year] && params[:month]
      year = params[:year].to_i
      month = params[:month].to_i
    else
      year = Date.today.year.to_i
      month = Date.today.month.to_i
    end

    reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date BETWEEN ? AND ?", current_user.id, Date.new(year, month, 1), (Date.new(year, month, 1) >> 1) - 1]).all

    @sales_hash = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = 0
      end
    end

    @drivers_hash = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = 0
      end
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

    @drivers = Driver.includes(:reports).where(["user_id = ? AND reports.date BETWEEN ? AND ?", current_user.id, Date.new(year, month, 1), (Date.new(year, month, 1) >> 1) - 1]).all

    reports.each do |report|
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

      @drivers_hash[report.driver_id][:mileage] += report.mileage if report.mileage
      @drivers_hash[report.driver_id][:riding_mileage] += report.riding_mileage if report.riding_mileage
      @drivers_hash[report.driver_id][:riding_count] += report.riding_count if report.riding_count
      @drivers_hash[report.driver_id][:meter_fare_count] += report.meter_fare_count if report.meter_fare_count
      @drivers_hash[report.driver_id][:passengers] += report.passengers if report.passengers
      @drivers_hash[report.driver_id][:sales] += report.sales if report.sales
      @drivers_hash[report.driver_id][:fuel_cost] += report.fuel_cost if report.fuel_cost
      @drivers_hash[report.driver_id][:ticket] += report.ticket if report.ticket
      @drivers_hash[report.driver_id][:account_receivable] += report.account_receivable if report.account_receivable
      @drivers_hash[report.driver_id][:cash] += report.cash if report.cash
      @drivers_hash[report.driver_id][:surplus_funds] += report.surplus_funds if report.surplus_funds
      @drivers_hash[report.driver_id][:deficiency_account] += report.deficiency_account if report.deficiency_account
      @drivers_hash[report.driver_id][:advance] += report.advance if report.advance
    end

    respond_to do |format|
      if params[:year] && params[:month]
        format.html # index.html.erb
      else
        format.html {redirect_to "#{sales_path}/#{Date.today.year}/#{Date.today.month}"}
      end
      format.json { render json: @sales }
    end
  end
end
