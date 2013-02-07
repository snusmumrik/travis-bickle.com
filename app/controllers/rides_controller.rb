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
      @ride = Ride.new(:report_id => params[:report_id],
                       :ride_latitude => params[:ride_latitude],
                       :ride_longitude => params[:ride_longitude],
                       :ride_address => params[:ride_address])
      respond_to do |format|
        if @ride.save(:validate => false)
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
      @ride.update_attributes({ :leave_latitude => params[:leave_latitude],
                                :leave_longitude => params[:leave_longitude],
                                :leave_address => params[:leave_address],
                                :passengers => params[:passengers],
                                :fare => params[:fare]
                              })

      respond_to do |format|
        if @ride.save
          format.json { render json: @ride.report }
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


  # GET /rides/new
  # GET /rides/new.json
  def new
    @ride = Ride.new
    @report = Report.find(params[:report_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ride }
    end
  end

  # POST /rides
  # POST /rides.json
  def create
    @ride = Ride.new(params[:ride])

    respond_to do |format|
      if @ride.save
        format.html { redirect_to report_path @ride.report, notice: t("activerecord.models.ride") + t("message.created") }
        format.json { render json: @ride, status: :created, location: @ride }
      else
        format.html { render action: "new" }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rides/1
  # PUT /rides/1.json
  def update
    @ride = Ride.find(params[:id])
    respond_to do |format|
      if @ride.update_attributes(params[:ride])
        format.html { redirect_to report_path(@ride.report), notice: 'Ride was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy

    respond_to do |format|
      format.html { redirect_to report_path(@ride.report) }
      format.json { head :ok }
    end
  end
end