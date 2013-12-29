class Api::RidesController < ApplicationController
  before_filter :authenticate_token
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /api/rides
  # POST /api/rides.jsonb
  def create
    unless @ride = Ride.where(["report_id = ? AND ended_at IS NULL", params[:report_id]]).first
      @ride = Ride.new(:report_id => params[:report_id],
                       :ride_latitude => params[:ride_latitude],
                       :ride_longitude => params[:ride_longitude],
                       :ride_address => params[:ride_address],
                       :started_at => Time.now()
                       )
    end

    respond_to do |format|
      if @ride.save(:validate => false)
        @advertisements = []
        images = Advertisement.includes(:images).collect(&:images).sort_by{rand}
        images.each do |image|
          @advertisements << image.last.image.url(:ipad_mini) if image.first
        end
        @json = Hash[:ride => {
                       :id => @ride.id,
                       :report_id => @ride.report_id,
                       :ride_latitude => @ride.ride_latitude,
                       :ride_longitude => @ride.ride_longitude,
                       :ride_address => @ride.ride_address
                     },
                     :advertisements => @advertisements
                    ]
        format.json { render json: @json, status: :created, location: @ride }
      else
        format.json { render json: {:error => "Ride creation failed."}, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/rides/1
  # PUT /api/rides/1.json
  def update
    if @ride = Ride.find(params[:id])
      @ride.update_attributes({ :leave_latitude => params[:leave_latitude],
                                :leave_longitude => params[:leave_longitude],
                                :leave_address => params[:leave_address],
                                :passengers => params[:passengers],
                                :fare => params[:fare],
                                :segment => params[:segment],
                                :ended_at => DateTime.now
                              })

      respond_to do |format|
        if @ride.save
          format.json { render json: @ride }
        else
          format.json { render json: {:error => "Ride update failed."}, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{ :error => "Not Acceptable:rides#update", :status => 406 } }
      end
    end
  end

  private
  def authenticate_token
    @car = Car.where(["device_token = ? AND deleted_at IS NULL", params[:device_token]]).order("updated_at DESC").first
    render json:{ :error => "Not Acceptable:rides#authenticate_token", :status => 406 } unless @car
  end
end
