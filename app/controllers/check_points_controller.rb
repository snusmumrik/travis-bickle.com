class CheckPointsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api_index
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /check_points
  # GET /check_points.json
  def api_index
    driver = Driver.find(params[:driver_id])
    @check_points = CheckPoint.where(["user_id = ? AND deleted_at IS NULL", driver.user_id]).all
    respond_to do |format|
      format.json { render json: @check_points }
    end
  end

  # GET /check_points
  # GET /check_points.json
  def index
    @check_points = CheckPoint.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:check_point]
      @check_points = @check_points.name_matches params[:check_point][:name]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @check_point }
    end
  end

  # POST /check_points
  # POST /check_points.json
  def create
    @check_point = CheckPoint.new(params[:check_point])
    @check_point.user = current_user

    respond_to do |format|
      if @check_point.save
        format.html { redirect_to check_points_path, notice: t("activerecord.models.check_point") + t("message.created") }
        format.json { render json: @check_point, status: :created, location: @check_point }
      else
        format.html { render action: "new" }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /check_points/1
  # PUT /check_points/1.json
  def update
    @check_point = CheckPoint.find(params[:id])
    respond_to do |format|
      if @check_point.update_attributes(params[:check_point])
        format.html { redirect_to @check_point, notice: 'Check Point was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_owner
    @check_point = CheckPoint.find(params[:id])
    redirect_to check_points_path if @check_point.user_id != current_user.id
  end
end
