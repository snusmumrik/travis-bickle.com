class TransferSlipsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :except => [:index, :new, :create]
  before_filter :authenticate_report_id_or_date, :only => [:index, :new]
  before_filter :prepare_options, :only => [:new, :create, :edit, :update]

  # GET /transfer_slips/new
  # GET /transfer_slips/new.json
  def new
    @transfer_slip = TransferSlip.new
    @report = Report.find(params[:report_id]) if params[:report_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transfer_slip }
    end
  end

  # GET /transfer_slips
  # GET /transfer_slips.json
  def index
    if params[:report_id]
      @transfer_slips = TransferSlip.where(["report_id = ?", params[:report_id]]).all
      @report = Report.find(params[:report_id])
    elsif params[:year] && params[:month] && params[:day]
      @transfer_slips = TransferSlip.where(["user_id = ? AND date = ?", current_user.id, "#{params[:year]}-#{params[:month]}-#{params[:day]}"])
    end

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
        if @transfer_slip.report
          redirect_path = report_path(@transfer_slip.report)
        else
          redirect_path = "#{reports_path}/#{@transfer_slip.date.year}/#{@transfer_slip.date.month}/#{@transfer_slip.date.day}"
        end
        format.html { redirect_to redirect_path, notice: t("activerecord.models.transfer_slip") + t("message.created") }
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
        if @transfer_slip.report
          redirect_path = report_path(@transfer_slip.report)
        else
          redirect_path = "#{reports_path}/#{@transfer_slip.date.year}/#{@transfer_slip.date.month}/#{@transfer_slip.date.day}"
        end
          format.html { redirect_to redirect_path, notice: t("activerecord.models.transfer_slip") + t("message.created") }
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
      if @transfer_slip.report
        redirect_path = report_path(@transfer_slip.report)
      else
        redirect_path = "#{reports_path}/#{@transfer_slip.date.year}/#{@transfer_slip.date.month}/#{@transfer_slip.date.day}"
      end
      format.html { redirect_to redirect_path, notice: t("activerecord.models.transfer_slip") + t("message.created") }
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
      redirect_to root_path if @transfer_slip.user != current_user
    end
  end

  def authenticate_report_id_or_date
    redirect_to root_path unless params[:report_id] || params[:year] || params[:month] || params[:day]
  end

  def prepare_options
    @credit_options = [[t("views.transfer_slip.credit_sales"), t("views.transfer_slip.credit_sales")],
                      [t("views.transfer_slip.credit_advance"), t("views.transfer_slip.credit_advance")],
                      [t("views.transfer_slip.credit_receivable"), t("views.transfer_slip.credit_receivable")]]
  end
end
