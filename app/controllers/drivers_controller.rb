class DriversController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api_signin
  before_filter :authenticate_owner, :only => [:show, :edit, :update]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /drivers
  # GET /drivers.json
  def api_signin
    respond_to do |format|
      @driver = Driver.where(["email = ?", params[:email]]).first
      if @driver && @driver.authenticate(params[:password])
        format.json { render json: @driver }
      else
        format.json { render json:{:error => "signin failed" } }
      end
    end
  end

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:driver]
      @drivers = @drivers.name_matches params[:driver][:name]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @driver }
    end
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
    @driver = Driver.find(params[:id])
    if params[:year] && params[:month] && params[:day]
      @reports = Report.where(["driver_id = ? AND date = ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)]).all
    elsif params[:year] && params[:month]
      @reports = Report.where(["driver_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(params[:year].to_i, params[:month].to_i, 1), (Date.new(params[:year].to_i, params[:month].to_i, 1) >> 1) - 1]).order("date").all
    else
      params[:year] = Date.today.year
      params[:month] = Date.today.month
      @reports = Report.where(["driver_id = ? AND date BETWEEN ? AND ?", params[:id], Date.new(Date.today.year.to_i, Date.today.month.to_i, 1), (Date.new(Date.today.year.to_i, Date.today.month.to_i, 1) >> 1) - 1]).all
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @driver }
    end
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(params[:driver])
    @driver.user = current_user

    respond_to do |format|
      if @driver.save
        format.html { redirect_to drivers_path, notice: t("activerecord.models.driver") + t("message.created") }
        format.json { render json: @driver, status: :created, location: @driver }
      else
        format.html { render action: "new" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_owner
    @driver = Driver.find(params[:id])
    redirect_to drivers_path if @driver.user_id != current_user.id
  end
end
