class ReportsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_show, :api_create, :api_update]
  before_filter :authenticate_owner, :except => [:api_show, :api_create, :api_update, :index]
  before_filter :get_drivers_option, :except => [:index, :show]
  before_filter :get_cars_option, :except => [:index, :show]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def api_show
    @report = Report.where(["car_id = ? AND driver_id = ? AND mileage IS NULL", params[:car_id], params[:driver_id]]).first
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
    @report = Report.where(["car_id = ? AND driver_id = ? AND mileage IS NULL", params[:car_id], params[:driver_id]]).first
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
    @report = Report.where(["car_id = ? AND driver_id = ? AND mileage IS NULL", params[:car_id], params[:driver_id]]).first
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
                                  :finished_at => DateTime.now
                                })


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
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date = ?", current_user.id, Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)]).order("car_id").all
    elsif params[:year] && params[:month]
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date BETWEEN ? AND ?", current_user.id, Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).order(["date", "car_id"]).page params[:page]
    else
      @reports = Report.includes(:car => :user).where(["cars.user_id = ? AND date BETWEEN ? AND ?", current_user.id, Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.includes(:car => :user).find(params[:id])
    @estimated_rest = 0

    @report.rests.each do |rest|
      @estimated_rest += rest.ended_at - rest.started_at
    end
    hours = @estimated_rest.divmod(60*60) #=> [12.0, 1800.0]
    mins = hours[1].divmod(60) #=> [30.0, 0.0]
    @estimated_rest = [hours[0], mins[0]]

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
