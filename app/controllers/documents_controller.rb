# -*- coding: utf-8 -*-
class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_driver_owner, :only => :index
  before_filter :authenticate_report_owner, :only => :show

  # GET /documents
  # GET /documents.json
  def index
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

    title = "労務時間報告書#{@reports[0].started_at.strftime('%Y%0m')}_(#{@reports[0].driver.name})" rescue "労務時間報告書"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reports }
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/reports/1
  # GET /documents/reports/1.json
  def show
    @title = "乗務記録簿 #{@report.started_at.strftime("%Y%m%d")} #{@report.driver.name}"
    @report = Report.find(params[:report_id])
    @estimated_rest = 0

    @report.rests.each do |rest|
      @estimated_rest += rest.ended_at - rest.started_at
    end
    hours = @estimated_rest.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @estimated_rest = [hours[0], mins[0]]

    @last_meter = @report.last_meter
    @check_points = CheckPoint.where(["user_id = ?", current_user.id]).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report }
      format.pdf do
        render :pdf => "乗務記録簿#{@report.started_at.strftime('%Y%m%0d')}_#{@report.driver.name}(#{@report.car.name})", :encoding => "UTF-8"
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
