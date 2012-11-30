class DriversController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /drivers
  # GET /drivers.json
  def api
    car = Car.includes(:user).where(["twitter_id = ?", params[:id]]).first
    @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL", car.user.id]).all
    respond_to do |format|
      format.json { render json: @drivers }
    end
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(params[:driver])
    @driver.user = current_user

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: t("activerecord.models.driver") + t("message.created") }
        format.json { render json: @driver, status: :created, location: @driver }
      else
        format.html { render action: "new" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end
end
