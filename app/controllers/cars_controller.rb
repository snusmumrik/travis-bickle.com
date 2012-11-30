class CarsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api

  # GET /cars
  # GET /cars.json
  def api
    car = Car.includes(:user).where(["twitter_id = ?", params[:id]]).first
    @cars = Car.where(["user_id = ? AND deleted_at IS NULL", car.user.id]).all
    respond_to do |format|
      format.json { render json: @cars }
    end
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(params[:car])
    @car.user = current_user

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: t("activerecord.models.car") + t("message.created") }
        format.json { render json: @car, status: :created, location: @car }
      else
        format.html { render action: "new" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end
end
