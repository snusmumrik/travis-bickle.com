# -*- coding: utf-8 -*-
class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_driver_owner, :only => :driver
  before_filter :authenticate_report_owner, :only => :report

  # GET /documents/:drivers/:year/:month/:day.pdf
  def roll_calls
    title = "点呼記録簿#{params[:year]}年#{params[:month]}月#{params[:day]}"
    @user = current_user
    @reports = Report.includes(:car, :driver).where(["cars.user_id = ? AND started_at BETWEEN ? AND ?",
                                               current_user.id,
                                               Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 00:00}"),
                                               Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 23:59}")
                                              ]).order("cars.name, drivers.name").all

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/driver/:id/:year/:month.pdf
  def driver
    title = "労務時間報告書#{@reports[0].started_at.strftime('%Y%0m')}_(#{@reports[0].driver.name})" rescue "労務時間報告書"

    @user = current_user
    @driver = Driver.find(params[:driver_id])

    params[:year] = Date.today.year unless params[:year]
    params[:month] = Date.today.month unless params[:month]

    @reports = Report.includes(:rests).where(["driver_id = ? AND started_at BETWEEN ? AND ?",
                                              params[:driver_id],
                                              Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-1 00:00}"),
                                              Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day} 23:59}")
                                             ]).order("started_at").all

    @working_hours = 0
    @rest_hours = 0
    @rest_hash = {}
    @late_night_hash = {}
    @late_night = 0
    @sales = 0
    @extra_sales = 0

    @report_hash = Hash.new do |hash, key|
      hash[key] = Array.new
    end

    @reports.each do |report|
      @report_hash[report.started_at.day] << report

      rest_time = 0
      report.rests.each do |rest|
        rest_time += rest.ended_at - rest.started_at if rest.ended_at
      end

      @working_hours += report.finished_at - report.started_at if report.finished_at
      @rest_hours += rest_time
      hours = rest_time.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.id, [hours[0], mins[0]])

      @sales += report.sales if report.sales
      @extra_sales += report.extra_sales if report.extra_sales

      if report.finished_at.nil?
        next
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
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/reports/1.pdf
  def report
    title = "乗務記録簿 #{@report.started_at.strftime("%Y%m%d")} #{@report.driver.name}"
    @user = current_user
    @report = Report.find(params[:report_id])
    @estimated_rest = 0

    @report.rests.each do |rest|
      @estimated_rest += rest.ended_at - rest.started_at
    end
    hours = @estimated_rest.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @estimated_rest = [hours[0], mins[0]]

    @last_meter = @report.last_meter

    @check_points = current_user.check_points
    @selected_status = {}
    @report.check_point_statuses.each do |status|
      @selected_status.store(status.check_point_id, status.status)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/salaries/:year/:month.pdf
  def salaries
    title = "#{params[:year]}年#{params[:month]} 給与一覧"

    params[:year] = Date.today.year unless params[:year]
    params[:month] = Date.today.month unless params[:month]

    @user = current_user
    @drivers = Driver.where(["user_id = ?", current_user.id]).all

    @salaries = Hash.new do |hash, key|
      hash[key] = Hash.new do |hash, key|
        hash[key] = Hash.new do |hash, key|
          hash[key] = 0
        end
      end
    end

    @reports = Report.where(["started_at BETWEEN ? AND ?",
                             Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-1 00:00}"),
                             Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day} 23:59}")
                            ]).all

    @reports.each do |report|
      @salaries[report.driver_id][report.started_at.day][:date] = report.started_at
      @salaries[report.driver_id][report.started_at.day][:sales] += report.sales + report.extra_sales
      @salaries[report.driver_id][report.started_at.day][:surplus_funds] += report.surplus_funds
      @salaries[report.driver_id][report.started_at.day][:deficiency_account] += report.deficiency_account
      @salaries[report.driver_id][:total][:sales] += report.sales + report.extra_sales
      @salaries[report.driver_id][:total][:surplus_funds] += report.surplus_funds
      @salaries[report.driver_id][:total][:deficiency_account] += report.deficiency_account
    end

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  private
  def authenticate_driver_owner
    @driver = Driver.find(params[:driver_id]) if params[:driver_id]
    redirect_to reports_path if @driver.try(:user_id) != current_user.id
  end

  def authenticate_report_owner
    @report = Report.find(params[:report_id])
    redirect_to reports_path if @report.car.user_id != current_user.id
  end
end
