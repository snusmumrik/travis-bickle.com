class PickupLocationsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]

  # GET /pickup_locations
  # GET /pickup_locations.json
  def index
    if params[:pickup_location]
      @pickup_locations = PickupLocation.where(["user_id = ?", current_user.id]).name_matches(params[:pickup_location][:name]).order("name")
    else
      @pickup_locations = PickupLocation.where(["user_id = ?", current_user.id]).order(:name).page params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @pickup_locations }
    end
  end

  # POST /pickup_locations
  # POST /pickup_locations.json
  def create
    @pickup_location = PickupLocation.new(params[:pickup_location])
    @pickup_location.user = current_user

    respond_to do |format|
      if @pickup_location.save
        format.html { redirect_to pickup_locations_path, notice: t("activerecord.models.pickup_location") + t("message.created") }
        format.json { render json: @pickup_location, status: :created, location: @pickup_location }
      else
        format.html { render action: "new" }
        format.json { render json: @pickup_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pickup_locations/1
  # PUT /pickup_locations/1.json
  def update
    @pickup_location = PickupLocation.find(params[:id])
    if coordinate = Geocoder.coordinates(params[:pickup_location][:address])
      params[:pickup_location][:latitude] = coordinate[0]
      params[:pickup_location][:longitude] = coordinate[1]
    end

    respond_to do |format|
      if @pickup_location.update_attributes(params[:pickup_location])
        format.html { redirect_to pickup_locations_path, notice: t("activerecord.models.pickup_location") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pickup_location.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def authenticate_owner
    @pickup_location = PickupLocation.find(params[:id])
    redirect_to pickup_locations_path if @pickup_location.user != current_user
  end
end
