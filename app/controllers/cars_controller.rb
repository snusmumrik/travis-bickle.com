class CarsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_index, :api_update]
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /cars
  # GET /cars.json
  def api_index
    driver = Driver.find(params[:driver_id])
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", driver.user_id]).all if driver
    respond_to do |format|
      format.json { render json: @cars }
    end
  end

  # PUT /cars/api_update
  # PUT /cars/api_update.json
  def api_update
    @car = Car.where(["id = ?", params[:car_id]]).first
    if @car
      @car.update_attributes({:device_token => params[:device_token]})

      respond_to do |format|
        if @car.save
          format.json { render json: @car }
        else
          format.json { render json: @car.errors }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{:error => "not found" } }
      end
    end
  end

  # GET /cars
  # GET /cars.json
  def index
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:car]
      @cars = @cars.name_matches params[:car][:name]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @car }
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
    @car = Car.find(params[:id])
    if params[:year] && params[:month] && params[:day]
      @reports = Report.where(["car_id = ? AND date = ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)]).all
    elsif params[:year] && params[:month]
      @reports = Report.where(["car_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).all
    else
      params[:year] = Date.today.year
      params[:month] = Date.today.month
      @reports = Report.where(["car_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car }
    end
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(params[:car])
    @car.user = current_user

    respond_to do |format|
      if @car.save
        format.html { redirect_to cars_path, notice: t("activerecord.models.car") + t("message.created") }
        format.json { render json: @car, status: :created, location: @car }
      else
        format.html { render action: "new" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_owner
    @car = Car.find(params[:id])
    redirect_to cars_path if @car.user_id != current_user.id
  end
end
