# -*- coding: utf-8 -*-
class ReportsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_show, :api_create, :api_update]
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  before_filter :get_drivers_option, :except => [:api_show, :api_create, :api_update, :index, :show]
  before_filter :get_cars_option, :except => [:api_show, :api_create, :api_update, :index, :show]
  before_filter :check_balance, :only => [:create, :update]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def api_show
    @report = Report.where(["car_id = ? AND driver_id = ? AND finished_at IS NULL", params[:car_id], params[:driver_id]]).first
    respond_to do |format|
      if @report
        format.json { render json: @report, status: :created, location: @report }
      else
        format.json { render json:{:error => "not found" } }
      end
    end
  end

  # POST /reports/api_create
  # POST /reports/api_create.jsonb
  def api_create
    if params[:device_token]
      car = Car.find(params[:car_id])
      car.update_attribute(:device_token, params[:device_token])
    end

    @report = Report.where(["car_id = ? AND driver_id = ? AND finished_at IS NULL", params[:car_id], params[:driver_id]]).first
    if @report
      @report.update_attribute(:updated_at, Time.now())
      respond_to do |format|
        format.json { render json: @report }
      end
    else
      @report = Report.new(:driver_id => params[:driver_id],
                           :car_id => params[:car_id],
                           :date => Date.today(),
                           :started_at => DateTime.now())

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
    @report = Report.find(params[:report_id])
    if @report
      @last_meter = @report.last_meter

      if meter = Meter.where(["report_id = ?", @report.id]).first
        meter.update_attributes({ :report_id => @report.id,
                                  :meter => params[:meter].presence || 0,
                                  :mileage => params[:mileage].presence || 0,
                                  :riding_mileage => params[:riding_mileage].presence || 0,
                                  :riding_count => @last_meter.riding_count + params[:riding_count].to_i,
                                  :meter_fare_count => @last_meter.meter_fare_count + params[:meter_fare_count].to_i })
      else
        Meter.create( :report_id => @report.id,
                      :meter => params[:meter],
                      :mileage => params[:mileage],
                      :riding_mileage => params[:riding_mileage],
                      :riding_count => @last_meter.riding_count + params[:riding_count].to_i,
                      :meter_fare_count => @last_meter.meter_fare_count + params[:meter_fare_count].to_i
                      )
      end

      credit = params[:cash].to_i + params[:ticket].to_i + params[:account_receivable].to_i + params[:fuel_cost].to_i + params[:advance].to_i
      debit = params[:sales].to_i
      if debit - credit > 0
        params[:deficiency_account] = debit - credit
        params[:surplus_funds] = 0
      elsif credit - debit > 0
        params[:surplus_funds] = credit - debit
        params[:deficiency_account] = 0
      end

      @report.update_attributes({ :mileage => params[:mileage].to_i - @last_meter.mileage,
                                  :riding_mileage => params[:riding_mileage].to_i - @last_meter.riding_mileage,
                                  :riding_count => params[:riding_count],
                                  :meter_fare_count => params[:meter_fare_count],
                                  :fuel_cost => params[:fuel_cost].presence || 0,
                                  :ticket => params[:ticket].presence || 0,
                                  :account_receivable => params[:account_receivable].presence || 0,
                                  :cash => params[:cash].presence || 0,
                                  :extra_sales => params[:extra_sales].presence || 0,
                                  :finished_at => DateTime.now})


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

  # GET /reports
  # GET /reports.json
  def index
    if params[:year] && params[:month] && params[:day]
      @reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND date = ?",
                                                       current_user.id,
                                                       Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
                                                      ]).order("cars.name, reports.started_at").all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月%-d日")} 日次成績" rescue "#{params[:year]}年#{params[:month]}月#{params[:day]} 日次成績"
    else
      @reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND date BETWEEN ? AND ?",
                                                       current_user.id,
                                                       Date.new(Date.today.year.to_i, Date.today.month.to_i, 1),
                                                       Date.new(Date.today.year.to_i, Date.today.month.to_i, -1)]).order("cars.name").all
      @title += " | #{@reports.first.date.strftime("%Y年%-m月")} 月次成績" rescue "#{params[:year]}年#{params[:month]}月 月次成績"
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
    @rest_hash = {}

    @reports.each do |report|
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

      rest_sum = 0
      report.rests.each do |rest|
        rest_sum += rest.ended_at - rest.started_at if rest.ended_at && rest.started_at
      end
      hours = rest_sum.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.id, [hours[0], mins[0]])
    end

    fuel_cost_rates = Array.new
    sales_array = @reports.collect(&:sales)
    @reports.collect(&:fuel_cost).each_with_index do |fuel_cost, i|
      if !sales_array[i].blank? && sales_array[i] != 0
        fuel_cost_rates << (fuel_cost.to_f / sales_array[i] * 100).ceil
      else
        fuel_cost_rates << 0
      end
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = @reports.collect { |item| item.car.name }
      f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      f.series(:type => "column", :name => t("activerecord.attributes.report.sales"), :yAxis => 0, :data => @reports.collect(&:sales), :tooltip => {:valueSuffix => "円"})
      f.series(:type => "column", :name => t("activerecord.attributes.report.extra_sales"), :yAxis => 0, :data => @reports.collect(&:extra_sales), :tooltip => {:valueSuffix => "円"})
      f.series(:type => "column", :name => t("activerecord.attributes.report.fuel_cost"), :yAxis => 0, :data => @reports.collect(&:fuel_cost), :tooltip => {:valueSuffix => "円"})
      f.series(:type => "spline", :name => t("views.report.fuel_cost_rate"), :yAxis => 1, :data => fuel_cost_rates, :tooltip => {:valueSuffix => "%"})

      f.yAxis [
               {:title => {:text => t("activerecord.attributes.report.sales") + "・" + t("activerecord.attributes.report.extra_sales") + "・" + t("activerecord.attributes.report.fuel_cost"), :margin => 70} },
               {:title => {:text => t("views.report.fuel_cost_rate")}, :opposite => true},
              ]
    end

    respond_to do |format|
      if params[:year] && params[:month] && params[:day]
        format.html # index.html.erb
      else
        format.html {redirect_to "#{reports_path}/#{Date.today.year}/#{Date.today.month}/#{Date.today.day}"}
      end
      format.json { render json: @report }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.includes(:car => :user).find(params[:id])
    @title += " | #{@report.date.strftime("%Y年%-m月%-d日")} 日次成績 #{@report.car.name} #{@report.driver.name}"
    rest_sum = 0
    @last_meter = @report.last_meter

    @report.rests.each do |rest|
      rest_sum += rest.ended_at - rest.started_at if rest.ended_at && rest.started_at
    end
    hours = rest_sum.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @rest_array = [hours[0], mins[0]]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
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
    @report.date = Date.today

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: t("activerecord.models.report") + t("message.created") }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      last_meter = @report.last_meter
      if @report.update_attributes({ :driver_id => params[:report][:driver_id],
                                     :car_id => params[:report][:car_id],
                                     :mileage => params[:report][:mileage].to_i - last_meter.mileage,
                                     :riding_mileage => params[:report][:riding_mileage].to_i - last_meter.riding_mileage,
                                     :riding_count => params[:report][:riding_count].to_i - last_meter.riding_count,
                                     :meter_fare_count => params[:report][:meter_fare_count].to_i - last_meter.meter_fare_count,
                                     :passengers => params[:report][:passengers].presence || 0,
                                     :sales => params[:report][:sales].presence || 0,
                                     :extra_sales => params[:report][:extra_sales].presence || 0,
                                     :fuel_cost => params[:report][:fuel_cost].presence || 0,
                                     :ticket => params[:report][:ticket].presence || 0,
                                     :account_receivable => params[:report][:account_receivable].presence || 0,
                                     :cash => params[:report][:cash].presence || 0,
                                     :surplus_funds => params[:report][:surplus_funds].presence || 0,
                                     :deficiency_account => params[:report][:deficiency_account].presence || 0,
                                     :advance => params[:report][:advance].presence || 0
                                   })

        if @report.meter
        @report.meter.update_attributes({ :meter => params[:report][:meter].presence || 0,
                                          :mileage => params[:report][:mileage].presence || 0,
                                          :riding_mileage => params[:report][:riding_mileage].presence || 0,
                                          :riding_count => params[:report][:riding_count].presence || 0,
                                          :meter_fare_count => params[:report][:meter_fare_count].presence || 0
                                        })
        else
          Meter.create( :report_id => @report.id,
                        :meter => params[:report][:meter].presence || 0,
                        :mileage => params[:report][:mileage].presence || 0,
                        :riding_mileage => params[:report][:riding_mileage].presence || 0,
                        :riding_count => params[:report][:riding_count].presence || 0,
                        :meter_fare_count => params[:report][:meter_fare_count].presence || 0
                        )
        end

        format.html { redirect_to @report, notice: t("activerecord.models.report") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.update_attribute("deleted_at", DateTime.now)

    respond_to do |format|
      format.html { redirect_to "#{reports_path}/#{@report.date.year}/#{@report.date.month}/#{@report.date.day}", notice: t("activerecord.models.report") + t("message.destroy") }
      format.json { head :ok }
    end
  end

  private
  def authenticate_owner
    @report = Report.find(params[:id])
    redirect_to reports_path if @report.car.user_id != current_user.id
  end

  def get_drivers_option
    @drivers_option = [[]]
    drivers = current_user.drivers.where("deleted_at is NULL").all
    drivers.each do |driver|
      @drivers_option << [driver.name, driver.id]
    end
  end

  def get_cars_option
    @cars_option = [[]]
    cars = current_user.cars.where("deleted_at is NULL").all
    cars.each do |car|
      @cars_option << [car.name, car.id]
    end
  end

  def check_balance
    credit = params[:report][:cash].to_i + params[:report][:ticket].to_i + params[:report][:account_receivable].to_i + params[:report][:fuel_cost].to_i + params[:report][:advance].to_i
    debit = params[:report][:sales].to_i + params[:report][:extra_sales].to_i
    if debit - credit >= 0
      params[:report][:deficiency_account] = debit - credit
      params[:report][:surplus_funds] = 0
    elsif credit - debit > 0
      params[:report][:surplus_funds] = credit - debit
      params[:report][:deficiency_account] = 0
    end
  end
end
