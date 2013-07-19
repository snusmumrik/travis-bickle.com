# -*- coding: utf-8 -*-
class SalesController < ApplicationController
  before_filter :authenticate_user!

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

    @title += " | #{year}年#{month}月 月次成績"

    @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND started_at BETWEEN ? AND ?",
                                                     current_user.id,
                                                     Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{1} 00:00}"),
                                                     Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day.to_s} 23:59}")
                                                     # Date.new(year, month, 1),
                                                     # Date.new(year, month, -1)
                                                    ]).all

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
    @extra_sales = 0
    @fuel_cost = 0
    @ticket = 0
    @account_receivable = 0
    @cash = 0
    @surplus_funds = 0
    @deficiency_account = 0
    @advance = 0

    @drivers = Driver.includes(:reports).where(["user_id = ? AND reports.started_at BETWEEN ? AND ?",
                                                current_user.id,
                                                Date.new(year, month, 1),
                                                Date.new(year, month, -1)]).all

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

      @drivers_hash[report.driver_id][:mileage] += report.mileage if report.mileage
      @drivers_hash[report.driver_id][:riding_mileage] += report.riding_mileage if report.riding_mileage
      @drivers_hash[report.driver_id][:riding_count] += report.riding_count if report.riding_count
      @drivers_hash[report.driver_id][:meter_fare_count] += report.meter_fare_count if report.meter_fare_count
      @drivers_hash[report.driver_id][:passengers] += report.passengers if report.passengers
      @drivers_hash[report.driver_id][:sales] += report.sales if report.sales
      @drivers_hash[report.driver_id][:extra_sales] += report.extra_sales if report.extra_sales
      @drivers_hash[report.driver_id][:fuel_cost] += report.fuel_cost if report.fuel_cost
      @drivers_hash[report.driver_id][:ticket] += report.ticket if report.ticket
      @drivers_hash[report.driver_id][:account_receivable] += report.account_receivable if report.account_receivable
      @drivers_hash[report.driver_id][:cash] += report.cash if report.cash
      @drivers_hash[report.driver_id][:surplus_funds] += report.surplus_funds if report.surplus_funds
      @drivers_hash[report.driver_id][:deficiency_account] += report.deficiency_account if report.deficiency_account
      @drivers_hash[report.driver_id][:advance] += report.advance if report.advance
    end

    @sales_array = Array.new
    for i in 1..Date.new(year, month, -1).day
      if @sales_hash[i]
        @sales_array << @sales_hash[i][:sales] + @sales_hash[i][:extra_sales]
      else
        @sales_array << 0
      end
    end

    @fuel_cost_array = Array.new
    for i in 1..Date.new(year, month, -1).day
      if @sales_hash[i]
        @fuel_cost_array << @sales_hash[i][:fuel_cost]
      else
        @fuel_cost_array << 0
      end
    end

    @driver_sales = Array.new
    @drivers.each do |driver|
      @driver_sales << @drivers_hash[driver.id][:sales] + @drivers_hash[driver.id][:extra_sales]
    end

    fuel_cost_rates = Array.new
    for i in 1..@sales_hash.size
      if (!@sales_hash[i][:sales].blank? && @sales_hash[i][:sales].to_i != 0) || (!@sales_hash[i][:extra_sales].blank? && @sales_hash[i][:extra_sales].to_i != 0)
        fuel_cost_rates << (@sales_hash[i][:fuel_cost].to_f / (@sales_hash[i][:sales].to_i + @sales_hash[i][:extra_sales]) * 100).ceil
      else
        fuel_cost_rates << 0
      end
    end

    @daily_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text => t("label.report.daily_total") })
      f.options[:xAxis][:categories] =  (1..Date.new(year, month, -1).day).to_a
      f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:type => 'column', :name => t("activerecord.attributes.report.sales") + "+" + t("activerecord.attributes.report.extra_sales"), :yAxis => 0, :data => @sales_array, :tooltip => {:valueSuffix => "円"})
      f.series(:type => "column", :name => t("activerecord.attributes.report.fuel_cost"), :yAxis => 0, :data => @fuel_cost_array, :tooltip => {:valueSuffix => "円"})
      f.series(:type => "spline", :name => t("views.report.fuel_cost_rate"), :yAxis => 1, :data => fuel_cost_rates, :tooltip => {:valueSuffix => "%"})

      f.yAxis [
               {:title => {:text => t("activerecord.attributes.report.sales") + "・" + t("activerecord.attributes.report.fuel_cost"), :margin => 70} },
               {:title => {:text => t("views.report.fuel_cost_rate")}, :opposite => true},
              ]
    end

    @driver_chart = LazyHighCharts::HighChart.new('column') do |f|
      f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:name => t("activerecord.attributes.report.sales") + "+" + t("activerecord.attributes.report.extra_sales"), :data => @driver_sales, :tooltip => {:valueSuffix => "円"})
      f.title({ :text => t("label.report.monthly_total") })
      f.options[:xAxis][:categories] = @drivers.collect(&:name)
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({:column=>{:stacking=>"normal"}})
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
