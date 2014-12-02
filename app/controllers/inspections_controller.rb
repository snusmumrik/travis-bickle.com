class InspectionsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  before_filter :set_options, :only => [:new, :create, :edit, :udate]

  # GET /inspections
  # GET /inspections.json
  def index
    @inspections = Inspection.joins(:car).where(["cars.user_id = ?", current_user.id]).order("date DESC").page params[:page]
  end

  # POST /inspections
  # POST /inspections.json
  def create
    @inspection = Inspection.new(params[:inspection])

    respond_to do |format|
      if @inspection.save
        format.html { redirect_to inspections_path, notice: t("activerecord.models.inspection") + t("message.created") }
        format.json { render json: @inspection, status: :created, location: @inspection }
      else
        format.html { render action: "new" }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inspections/1
  # PUT /inspections/1.json
  def update
    @inspection = Inspection.find(params[:id])

    respond_to do |format|
      if @inspection.update_attributes(params[:inspection])
        format.html { redirect_to inspections_path, notice: t("activerecord.models.inspection") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_owner
    @inspection = Inspection.find(params[:id])
    redirect_to inspections_path if @inspection.car.user_id != current_user.id
  end

  def set_options
    @car_option = Array.new
    Car.where(["user_id = ? AND deleted_at IS NULL", current_user.id]).order(:name).each do |car|
      @car_option << [car.name, car.id]
    end
  end
end
