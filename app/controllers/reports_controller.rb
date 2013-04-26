class ReportsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_show, :api_create, :api_update]
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  before_filter :get_drivers_option, :except => [:index, :show]
  before_filter :get_cars_option, :except => [:index, :show]
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
    @report = Report.where(["car_id = ? AND driver_id = ? AND finished_at IS NULL", params[:car_id], params[:driver_id]]).first
    if @report
      passengers = 0
      sales = 0
      begin
        rides = Ride.where(["report_id = ?", @report.id]).all
        rides.each do |ride|
          passengers += ride.passengers
          sales += ride.fare
        end
      rescue
      end

      @report.update_attributes({ :meter => params[:meter],
                                  :mileage => params[:mileage],
                                  :riding_mileage => params[:riding_mileage],
                                  :riding_count => params[:riding_count],
                                  :meter_fare_count => params[:meter_fare_count],
                                  :passengers => passengers,
                                  :sales => sales,
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
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date = ?",
                                                       current_user.id,
                                                       Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
                                                      ]).order("car_id").all
    elsif params[:year] && params[:month]
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date BETWEEN ? AND ?",
                                                       current_user.id,
                                                       Date.new(params[:year].to_i, params[:month].to_i, 1),
                                                       Date.new(params[:year].to_i, params[:month].to_i, -1)
                                                      ]).order(["date", "car_id"]).page params[:page]
    else
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date BETWEEN ? AND ?",
                                                       current_user.id,
                                                       Date.new(Date.today.year.to_i, Date.today.month.to_i, 1),
                                                       Date.new(Date.today.year.to_i, Date.today.month.to_i, -1)]).all
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
    @rest_hash = {}

    @reports.each do |report|
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

      rest_sum = 0
      report.rests.each do |rest|
        rest_sum += rest.ended_at - rest.started_at
      end
      hours = rest_sum.divmod(60*60) #=> [12.0, 1800.0]
      mins = hours[1].divmod(60) #=> [30.0, 0.0]
      @rest_hash.store(report.id, [hours[0], mins[0]])
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
    rest_sum = 0

    @report.rests.each do |rest|
      rest_sum += rest.ended_at - rest.started_at
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

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])
    respond_to do |format|
      if @report.update_attributes(params[:report])
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
    drivers = Driver.where("deleted_at is NULL").all
    drivers.each do |driver|
      @drivers_option << [driver.name, driver.id]
    end
  end

  def get_cars_option
    @cars_option = [[]]
    cars = Car.where("deleted_at is NULL").all
    cars.each do |car|
      @cars_option << [car.name, car.id]
    end
  end
end
