# -*- coding: utf-8 -*-
class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_driver_owner, :only => :driver
  before_filter :authenticate_report_owner, :only => :report

  # GET /documents/:daily_sales/:year/:month/:day.pdf
  def daily_sales
    title = "#{params[:year]}年#{params[:month]}月#{params[:day]}日 売上一覧"
    @reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND reports.started_at BETWEEN ? AND ?",
                                                             current_user.id,
                                                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 00:00}"),
                                                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 23:59}")
                                                            ]).order("cars.name, reports.started_at").all

    @transfer_slips = TransferSlip.where(["user_id = ? AND date = ?", current_user.id, "#{params[:year]}-#{params[:month]}-#{params[:day]}"])
    @transfer_slips = TransferSlip.includes(:report).where(["transfer_slips.user_id = ? AND (date = ? OR reports.started_at BETWEEN ? AND ?)",
                                                            current_user.id,
                                                            "#{params[:year]}-#{params[:month]}-#{params[:day]}",
                                                            Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 00:00}"),
                                                            Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 23:59}")
                                                           ]).all
    @transfer_slip_amount = 0
    @transfer_slips.each do |transfer_slip|
      @transfer_slip_amount += transfer_slip.debit_amount
    end

    @title += " | #{@reports.first.started_at.strftime("%Y年%-m月%-d日")} #{t('views.report.index')}" rescue "#{params[:year]}年#{params[:month]}月#{params[:day]} #{t('views.report.index')}"

    @mileage = 0
    @riding_mileage = 0
    @riding_count = 0
    @meter_fare_count = 0
    @passengers = 0
    @sales = 0
    @extra_sales = 0
    @fuel_cost = 0
    @fuel_cost_lpg = 0
    @ticket = 0
    @account_receivable = 0
    @cash = 0
    @edy = 0
    @surplus_funds = 0
    @deficiency_account = 0
    @advance = 0
    @rest_hash = {}
    @sales_array = Array.new

    @reports.each do |report|
      @mileage += report.mileage if report.mileage
      @riding_mileage += report.riding_mileage if report.riding_mileage
      @riding_count += report.riding_count if report.riding_count
      @meter_fare_count += report.meter_fare_count if report.meter_fare_count
      @passengers += report.passengers if report.passengers
      @sales += report.sales if report.sales
      @extra_sales += report.extra_sales if report.extra_sales
      @fuel_cost += report.fuel_cost if report.fuel_cost
      @fuel_cost_lpg += report.fuel_cost_lpg if report.fuel_cost_lpg
      @ticket += report.ticket if report.ticket
      @account_receivable += report.account_receivable if report.account_receivable
      @cash += report.cash if report.cash
      @edy += report.edy if report.edy
      @surplus_funds += report.surplus_funds if report.surplus_funds
      @deficiency_account += report.deficiency_account if report.deficiency_account
      @advance += report.advance if report.advance

      rest_sum = 0
      report.rests.each do |rest|
        rest_sum += rest.ended_at - rest.started_at if rest.ended_at && rest.started_at
      end
      hours = rest_sum.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.id, [hours[0], mins[0]])
      @sales_array << report.sales + report.extra_sales
    end

    fuel_cost_rates = Array.new
    sales_array = @reports.collect(&:sales)
    extra_sales_array = @reports.collect(&:extra_sales)
    @reports.each_with_index do |report, i|
      if (!sales_array[i].blank? && sales_array[i] != 0) || (!extra_sales_array[i].blank? && extra_sales_array[i] != 0)
        fuel_cost_rates << ((report.fuel_cost.to_f + report.fuel_cost_lpg.to_f) / (sales_array[i] + extra_sales_array[i]) * 100).ceil
      else
        fuel_cost_rates << 0
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/:roll_calls/:year/:month/:day.pdf
  def roll_calls
    title = "#{params[:year]}年#{params[:month]}月#{params[:day]}日 点呼記録簿"
    @user = current_user
    @reports = Report.includes(:car, :driver).where(["cars.user_id = ? AND started_at BETWEEN ? AND ?",
                                               current_user.id,
                                               Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 00:00}"),
                                               Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 23:59}")
                                              ]).order("cars.name, drivers.name").all

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # # GET /documents/drivers/:id/:year.pdf
  # def tax_withholding
  #   title = "所得税源泉徴収簿 #{@reports[0].started_at.strftime('%Y%0m')}_(#{@reports[0].driver.name})" rescue "所得税源泉徴収簿"

  #   @driver = Driver.find(params[:driver_id])

  #   params[:year] = Date.today.year unless params[:year]

  #   @reports = Report.where(["driver_id = ? AND started_at BETWEEN ? AND ?",
  #                            params[:driver_id],
  #                            Time.zone.parse("#{params[:year].to_s}-1-1 00:00}"),
  #                            Time.zone.parse("#{params[:year].to_s}-12-31 23:59}")
  #                           ]).order("started_at").all

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.pdf do
  #       # render :pdf => title, :orientation => "Landscape", :encoding => "UTF-8"
  #       render :pdf => title, :encoding => "UTF-8"
  #     end
  #   end
  # end

  # GET /documents/drivers/:id/:year/:month.pdf
  def driver
    title = "労務時間報告書#{@reports[0].started_at.strftime('%Y%0m')}_(#{@reports[0].driver.name})" rescue "労務時間報告書"

    @user = current_user
    @driver = Driver.find(params[:driver_id])

    params[:year] = Date.today.year unless params[:year]
    params[:month] = Date.today.month unless params[:month]

    @reports = Report.includes(:rests).where(["driver_id = ? AND started_at BETWEEN ? AND ?",
                                              params[:driver_id],
                                              Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-1 00:00}"),
                                              Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day} 23:59}")
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
      @estimated_rest += rest.ended_at - rest.started_at if rest.ended_at && rest.started_at
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
                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-1 00:00}"),
                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day} 23:59}")
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
        render :pdf => title, :orientation => "Landscape", :encoding => "UTF-8"
      end
    end
  end

  # GET /documents/inspections/:yearpdf
  def inspections
    title = "#{params[:year]}年 #{t('activerecord.models.inspection')}"

    @inspections = Hash.new do |hash, key|
      hash[key] = Hash.new
    end

    @cars = Car.where(["cars.user_id = ? AND cars.deleted_at IS NULL", current_user.id]).order("cars.name")

    inspections = Inspection.joins(:car).where(["cars.user_id = ? AND inspections.date BETWEEN ? AND ?",
                                                 current_user.id,
                                                 Date.new(params[:year].to_i - 1, 1, 1),
                                                 Date.new(params[:year].to_i, 12, 31)])

    inspections.each do |inspection|
      if inspection.date.year == params[:year].to_i
        @inspections[inspection.car_id].store(inspection.date.month, ["車検", inspection.date])
      end

      if inspection.span < 12
        for i in 1..12/inspection.span
          next_implementation = inspection.date >> inspection.span*i
          if next_implementation.year == params[:year].to_i && @inspections[inspection.car_id][next_implementation.month].blank?
            @inspections[inspection.car_id].store(next_implementation.month, ["点検"])
          end
        end
      end
    end

    # raise @inspections.inspect

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => title, :orientation => "Landscape", :encoding => "UTF-8"
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
