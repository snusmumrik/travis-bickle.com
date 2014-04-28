class TransferSlipsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :except => [:index, :new, :create]
  before_filter :authenticate_report_id, :only => [:index, :new]
  before_filter :prepare_options, :only => [:new, :create, :edit, :update]

  # GET /transfer_slips
  # GET /transfer_slips.json
  def index
    @transfer_slips = TransferSlip.where(["report_id = ?", params[:report_id]]).all
    @report = Report.find(params[:report_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transfer_slips }
    end
  end

  # POST /transfer_slips
  # POST /transfer_slips.json
  def create
    redirect_to root_path unless params[:transfer_slip][:report_id]
    @transfer_slip = TransferSlip.new(params[:transfer_slip])

    respond_to do |format|
      if @transfer_slip.save
        format.html { redirect_to report_path(@transfer_slip.report), notice: t("activerecord.models.transfer_slip") + t("message.created") }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /transfer_slips/1
  # PUT /transfer_slips/1.json
  def update
    @transfer_slip = TransferSlip.find(params[:id])

    respond_to do |format|
      if @transfer_slip.update_attributes(params[:transfer_slip])
        format.html { redirect_to report_path(@transfer_slip.report), notice: t("activerecord.models.transfer_slip") + t("message.updated") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /transfer_slips/1
  # DELETE /transfer_slips/1.json
  def destroy
    @transfer_slip.destroy

    respond_to do |format|
      format.html { redirect_to report_path(@transfer_slip.report), notice: t("activerecord.models.transfer_slip") + t("message.updated") }
      format.json { head :ok }
    end
  end

  private
  def authenticate_owner
    if params[:report_id]
      @report = Report.find(params[:report_id])
      redirect_to root_path if @report.driver.user != current_user
    else
      @transfer_slip = TransferSlip.find(params[:id])
      redirect_to root_path if @transfer_slip.report.driver.user != current_user
    end
  end

  def authenticate_report_id
    redirect_to root_path unless params[:report_id]
  end

  def prepare_options
    @credit_options = [[t("views.transfer_slip.credit_sales"), t("views.transfer_slip.credit_sales")],
                      [t("views.transfer_slip.credit_advance"), t("views.transfer_slip.credit_advance")],
                      [t("views.transfer_slip.credit_receivable"), t("views.transfer_slip.credit_receivable")]]
  end
end
