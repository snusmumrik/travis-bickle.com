# -*- Coding: utf-8 -*-
class ReportsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  before_filter :get_drivers_option, :except => [:index, :show]
  before_filter :get_cars_option, :except => [:index, :show]
  before_filter :check_balance, :only => [:create, :update]
  before_filter :set_check_points, :only => [:new, :create, :edit, :update, :show]
  after_filter :set_check_point_status, :only => [:new, :create, :edit, :update]

  # GET /reports/:year/:month/:day
  # GET /reports/:year/:month/:day.json
  def index
    params[:year] = Date.today.year unless params[:year]
    params[:month] = Date.today.month unless params[:month]
    params[:day] = Date.today.day unless params[:day]

    @reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND reports.started_at BETWEEN ? AND ?",
                                                             current_user.id,
                                                             Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 00:00}"),
                                                             Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{params[:day].to_s} 23:59}")
                                                            ]).order("cars.name, reports.started_at").all
    @title += " | #{@reports.first.started_at.strftime("%Y年%-m月%-d日")} #{t('views.report.index')}" rescue "#{params[:year]}年#{params[:month]}月#{params[:day]} #{t('views.report.index')}"

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
      @sales_array << report.sales + report.extra_sales
    end

    fuel_cost_rates = Array.new
    sales_array = @reports.collect(&:sales)
    extra_sales_array = @reports.collect(&:extra_sales)
    @reports.collect(&:fuel_cost).each_with_index do |fuel_cost, i|
      if (!sales_array[i].blank? && sales_array[i] != 0) || (!extra_sales_array[i].blank? && extra_sales_array[i] != 0)
        fuel_cost_rates << (fuel_cost.to_f / (sales_array[i] + extra_sales_array[i]) * 100).ceil
      else
        fuel_cost_rates << 0
      end
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => t("activerecord.attributes.report.sales"))
      f.options[:xAxis][:categories] = @reports.collect { |item| item.car.name }
      f.labels(:items => [:html => "", :style => {:left => "40px", :top => "8px", :color => "black"} ])
      # f.series(:type => "column", :name => t("activerecord.attributes.report.sales"), :yAxis => 0, :data => @reports.collect(&:sales), :tooltip => {:valueSuffix => "円"})
      # f.series(:type => "column", :name => t("activerecord.attributes.report.extra_sales"), :yAxis => 0, :data => @reports.collect(&:extra_sales), :tooltip => {:valueSuffix => "円"})
      f.series(:type => 'column', :name => t("activerecord.attributes.report.sales") + "+" + t("activerecord.attributes.report.extra_sales"), :yAxis => 0, :data => @sales_array, :tooltip => {:valueSuffix => "円"})
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

  # GET /sales/:year/:month
  # GET /sales/:year/:month/:day.json
  def daily
    if params[:year] && params[:month]
      year = params[:year].to_i
      month = params[:month].to_i
    else
      year = Date.today.year.to_i
      month = Date.today.month.to_i
    end

    @title += " | #{year}年#{month}月 #{t('views.report.daily')}"

    @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND started_at BETWEEN ? AND ?",
                                                     current_user.id,
                                                     Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{1} 00:00}"),
                                                     Time.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day.to_s} 23:59}")
                                                    ]).all

    @report_hash = Hash.new do |hash, key|
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
      @report_hash[report.started_at.day][:mileage] += report.mileage if report.mileage
      @report_hash[report.started_at.day][:riding_mileage] += report.riding_mileage if report.riding_mileage
      @report_hash[report.started_at.day][:riding_count] += report.riding_count if report.riding_count
      @report_hash[report.started_at.day][:meter_fare_count] += report.meter_fare_count if report.meter_fare_count
      @report_hash[report.started_at.day][:passengers] += report.passengers if report.passengers
      @report_hash[report.started_at.day][:sales] += report.sales if report.sales
      @report_hash[report.started_at.day][:extra_sales] += report.extra_sales if report.extra_sales
      @report_hash[report.started_at.day][:fuel_cost] += report.fuel_cost if report.fuel_cost
      @report_hash[report.started_at.day][:ticket] += report.ticket if report.ticket
      @report_hash[report.started_at.day][:account_receivable] += report.account_receivable if report.account_receivable
      @report_hash[report.started_at.day][:cash] += report.cash if report.cash
      @report_hash[report.started_at.day][:surplus_funds] += report.surplus_funds if report.surplus_funds
      @report_hash[report.started_at.day][:deficiency_account] += report.deficiency_account if report.deficiency_account
      @report_hash[report.started_at.day][:advance] += report.advance if report.advance

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
      if @report_hash[i]
        @sales_array << @report_hash[i][:sales] + @report_hash[i][:extra_sales]
      else
        @sales_array << 0
      end
    end

    @fuel_cost_array = Array.new
    for i in 1..Date.new(year, month, -1).day
      if @report_hash[i]
        @fuel_cost_array << @report_hash[i][:fuel_cost]
      else
        @fuel_cost_array << 0
      end
    end

    @driver_sales = Array.new
    @drivers.each do |driver|
      @driver_sales << @drivers_hash[driver.id][:sales] + @drivers_hash[driver.id][:extra_sales]
    end

    fuel_cost_rates = Array.new
    for i in 1..@report_hash.size
      if (!@report_hash[i][:sales].blank? && @report_hash[i][:sales].to_i != 0) || (!@report_hash[i][:extra_sales].blank? && @report_hash[i][:extra_sales].to_i != 0)
        fuel_cost_rates << (@report_hash[i][:fuel_cost].to_f / (@report_hash[i][:sales].to_i + @report_hash[i][:extra_sales]) * 100).ceil
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
        format.html {redirect_to "#{reports_path}/#{Date.today.year}/#{Date.today.month}"}
      end
      format.json { render json: @sales }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.includes(:car => :user).find(params[:id])
    @title += " | #{@report.started_at.strftime("%Y年%-m月%-d日")} 日次成績 #{@report.car.name} #{@report.driver.name}"
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
    @report.driver_id = params[:driver_id]
    @report.car_id = params[:car_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])
    @report.started_at = @report.started_at.in_time_zone("Tokyo") if @report.started_at

    respond_to do |format|
      if @report.save
        @last_meter = @report.last_meter

        finished_at = Time.parse("#{params[:report]["finished_at(1i)"].to_s}-#{params[:report]["finished_at(2i)"].to_s}-#{params[:report]["finished_at(3i)"].to_s} #{params[:report]["finished_at(4i)"].to_s}:#{params[:report]["finished_at(5i)"].to_s}") rescue nil

        @report.update_attributes({ :mileage => params[:report][:mileage].to_i - @last_meter.mileage,
                                    :riding_mileage => params[:report][:riding_mileage].to_i - @last_meter.riding_mileage,
                                    :riding_count => params[:report][:riding_count].to_i - @last_meter.riding_count,
                                    :meter_fare_count => params[:report][:meter_fare_count].to_i - @last_meter.meter_fare_count,
                                    :fuel_cost => params[:report][:fuel_cost].presence || 0,
                                    :ticket => params[:report][:ticket].presence || 0,
                                    :account_receivable => params[:report][:account_receivable].presence || 0,
                                    :cash => params[:report][:cash].presence || 0,
                                    :sales => params[:report][:sales].presence || 0,
                                    :extra_sales => params[:report][:extra_sales].presence || 0,
                                    :surplus_funds => params[:report][:surplus_funds],
                                    :deficiency_account => params[:report][:deficiency_account],
                                    :finished_at => finished_at})

        if meter = Meter.where(["report_id = ?", @report.id]).first
          meter.update_attributes({ :meter => params[:report][:meter].presence || 0,
                                    :mileage => params[:report][:mileage].presence || 0,
                                    :riding_mileage => params[:report][:riding_mileage].presence || 0,
                                    :riding_count => params[:report][:riding_count].to_i,
                                    :meter_fare_count => params[:report][:meter_fare_count].to_i })
        else
          Meter.create( :report_id => @report.id,
                        :meter => params[:report][:meter],
                        :mileage => params[:report][:mileage],
                        :riding_mileage => params[:report][:riding_mileage],
                        :riding_count => params[:report][:riding_count].to_i,
                        :meter_fare_count => params[:report][:meter_fare_count].to_i
                        )
        end

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

    finished_at = Time.parse("#{params[:report]["finished_at(1i)"].to_s}-#{params[:report]["finished_at(2i)"].to_s}-#{params[:report]["finished_at(3i)"].to_s} #{params[:report]["finished_at(4i)"].to_s}:#{params[:report]["finished_at(5i)"].to_s}") rescue nil

    respond_to do |format|
      @last_meter = @report.last_meter
      if @report.update_attributes({ :driver_id => params[:report][:driver_id],
                                     :car_id => params[:report][:car_id],
                                     :mileage => params[:report][:mileage].to_i - @last_meter.mileage,
                                     :riding_mileage => params[:report][:riding_mileage].to_i - @last_meter.riding_mileage,
                                     :riding_count => params[:report][:riding_count].to_i - @last_meter.riding_count,
                                     :meter_fare_count => params[:report][:meter_fare_count].to_i - @last_meter.meter_fare_count,
                                     :passengers => params[:report][:passengers].presence || 0,
                                     :sales => params[:report][:sales].presence || 0,
                                     :extra_sales => params[:report][:extra_sales].presence || 0,
                                     :fuel_cost => params[:report][:fuel_cost].presence || 0,
                                     :ticket => params[:report][:ticket].presence || 0,
                                     :account_receivable => params[:report][:account_receivable].presence || 0,
                                     :cash => params[:report][:cash].presence || 0,
                                     :surplus_funds => params[:report][:surplus_funds].presence || 0,
                                     :deficiency_account => params[:report][:deficiency_account].presence || 0,
                                     :advance => params[:report][:advance].presence || 0,
                                     :started_at => Time.parse("#{params[:report]["started_at(1i)"].to_s}-#{params[:report]["started_at(2i)"].to_s}-#{params[:report]["started_at(3i)"].to_s} #{params[:report]["started_at(4i)"].to_s}:#{params[:report]["started_at(5i)"].to_s}"),
                                     :finished_at => finished_at

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
    @report.destroy

    respond_to do |format|
      format.html { redirect_to "#{reports_path}/#{@report.started_at.year}/#{@report.started_at.month}/#{@report.started_at.day}", notice: t("activerecord.models.report") + t("message.destroy") }
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

  def set_check_points
    @check_points = current_user.check_points
    @selected_status = {}
    @status_options = [["点検良", "レ"], ["調整要ス", "A"], ["修理要ス", "△"], ["補給", "L"]]
    if @report
      @report.check_point_statuses.each do |status|
        @selected_status.store(status.check_point_id, status.status)
      end
    end
  end

  def set_check_point_status
    if params[:report] && params[:report][:check_point_statuses]
      params[:report][:check_point_statuses].each do |status|
        check_point_status = CheckPointStatus.where(["report_id = ? AND check_point_id = ?", @report.id, status[0]]).first
        if status[1] == "レ"
          check_point_status.delete if check_point_status
        else
          if check_point_status
            check_point_status.update_attribute(:status, status[1])
          else
            CheckPointStatus.create(:report_id => @report.id,
                                    :check_point_id => status[0],
                                    :status => status[1])
          end
        end
      end
    end
  end
end
