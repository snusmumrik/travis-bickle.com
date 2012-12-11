class LocationsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => :api_update
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # PUT /locations/api_update
  # PUT /locations/api_update.json
  def api_update
    @location = Location.where(["car_id = ?", params[:car_id]]).first || Location.new(:car_id => params[:car_id])

    @location.address = params[:address]
    @location.latitude = params[:latitude]
    @location.longitude = params[:longitude]

    respond_to do |format|
      if @location.save
        format.json { render json: @location, status: :created, location: @location }
      else
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.includes(:car => :user).where(["users.id = ?", current_user.id]).order("car_id").all
    @json = Location.all.to_gmaps4rails do |location, marker|
      marker.picture({
                  :picture => "http://chart.apis.google.com/chart?chst=d_map_spin&chld=1.1|0|FFB573|12|_|#{location.car.name}",
                  :width   => 100,
                  :height  => 100
                 })
      marker.infowindow "<img src=\"http://maruchiku.jp/images/img_cars02.jpg\"><br />#{location.car.name}"
      marker.title location.car.name
      marker.json({:car_id => location.car.id, :foo => "bar" })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @location }
    end
  end
end
