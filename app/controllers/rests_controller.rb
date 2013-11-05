class RestsController < InheritedResources::Base
  before_filter :authenticate_user!

  # GET /rests
  # GET /rests.json
  def index
    redirect_to root_path
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
    @rest.destroy

    respond_to do |format|
      format.html { redirect_to @rest.report, notice: t("activerecord.models.rest") + t("message.destroy") }
      format.json { head :ok }
    end
  end
end
