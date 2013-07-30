class RestsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:api_create, :api_update]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /rests/api_create
  # POST /rests/api_create.jsonb
  def api_create
    @rest = Rest.new(:report_id => params[:report_id],
                     :latitude => params[:latitude],
                     :longitude => params[:longitude],
                     :address => params[:address],
                     :started_at => Time.now()
                     )

    respond_to do |format|
      if @rest.save
        @json = Hash[:rest => {:id => @rest.id, :report_id => @rest.report_id, :latitude => @rest.latitude, :longitude => @rest.longitude, :address => @rest.address}]
        format.json { render json: @json, status: :created, location: @json }
      else
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rests/api_update
  # PUT /rests/api_update.json
  def api_update
    @rest = Rest.find(params[:rest_id])
    if @rest
      @rest.update_attributes({ :location => params[:location],
                                :ended_at => DateTime.now })

      respond_to do |format|
        if @rest.save
          format.json { render json: @rest }
        else
          format.json { render json: @rest.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{:error => "not found" } }
      end
    end
  end

  # GET /rests/new
  # GET /rests/new.json
  def new
    @rest = Rest.new
    @report = Report.find(params[:report_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rest }
    end
  end

  # GET /rests/1/edit
  def edit
    @rest = Rest.find(params[:id])
    @report = @rest.report
  end

  # POST /rests
  # POST /rests.json
  def create
    @rest = Rest.new(params[:rest])

    respond_to do |format|
      if @rest.save
        format.html { redirect_to @rest.report, notice: t("activerecord.models.rest") + t("message.created") }
        format.json { render json: @rest, status: :created, location: @rest }
      else
        format.html { render action: "new" }
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rests/1
  # PUT /rests/1.json
  def update
    @rest = Rest.find(params[:id])
    respond_to do |format|
      if @rest.update_attributes(params[:rest])
        format.html { redirect_to @rest.report, notice: t("activerecord.models.rest") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rests/1
  # DELETE /rests/1.json
  def destroy
    @rest = Rest.find(params[:id])
    @rest.update_attribute("deleted_at", DateTime.now)

    respond_to do |format|
      format.html { redirect_to @rest.report, notice: t("activerecord.models.rest") + t("message.destroy") }
      format.json { head :ok }
    end
  end
end
