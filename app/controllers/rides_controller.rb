class RidesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_create, :api_update]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /rides/api_create
  # POST /rides/api_create.jsonb
  def api_create
    if @ride = Ride.where(["report_id = ? AND fare IS NULL", params[:report_id]]).first
      respond_to do |format|
        format.json { render json: @ride, status: :created, location: @ride }
        # format.json { render json:{:error => "duplicate ride" } }
      end
    else
      @ride = Ride.new(:report_id => params[:report_id], :ride_latitude => params[:ride_latitude], :ride_longitude => params[:ride_longitude])
      respond_to do |format|
        if @ride.save
          format.json { render json: @ride, status: :created, location: @ride }
        else
          format.json { render json: @ride.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /rides/api_update
  # PUT /rides/api_update.json
  def api_update
    @ride = Ride.where(["report_id = ? AND fare IS NULL", params[:report_id]]).first
    if @ride
      @ride.leave_latitude = params[:leave_latitude]
      @ride.leave_longitude = params[:leave_longitude]
      @ride.passengers = params[:passengers]
      @ride.fare = params[:fare]

      respond_to do |format|
        if @ride.save
          format.json { render json: @ride, status: :created, location: @ride }
        else
          format.json { render json: @ride.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{:error => "not found" } }
      end
    end
  end
end
