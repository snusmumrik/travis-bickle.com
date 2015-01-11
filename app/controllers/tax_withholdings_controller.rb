# -*- coding: utf-8 -*-
class TaxWithholdingsController < InheritedResources::Base
  before_filter :set_tax_withholding, :only => [:show, :edit, :update, :delete]
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :except => [:index, :new, :create]
  before_filter :prepare_options, :only => [:new, :create, :edit, :update]

  # GET /tax_withholdings/new/:driver_id/:year/:month
  # GET /tax_withholdings/new/:driver_id/:year/:month.json
  def new
    @tax_withholding = TaxWithholding.new
    if tax_withholding = TaxWithholding.where(["driver_id = ?", params[:driver_id]]).order("date DESC").first
      @tax_withholding.working_days = tax_withholding.working_days
      @tax_withholding.working_hours = tax_withholding.working_hours
      @tax_withholding.holiday_working_hours = tax_withholding.holiday_working_hours
      @tax_withholding.night_working_hours = tax_withholding.night_working_hours
      @tax_withholding.extra_working_hours = tax_withholding.extra_working_hours
      @tax_withholding.base_salary = tax_withholding.base_salary
      @tax_withholding.percentage_pay = tax_withholding.percentage_pay
      @tax_withholding.holiday_pay = tax_withholding.holiday_pay
      @tax_withholding.night_pay = tax_withholding.night_pay
      @tax_withholding.extra_pay = tax_withholding.extra_pay
      @tax_withholding.no_absence_pay = tax_withholding.no_absence_pay
      @tax_withholding.no_accident_pay = tax_withholding.no_accident_pay
      @tax_withholding.long_service_pay = tax_withholding.long_service_pay
      @tax_withholding.real_salary = tax_withholding.real_salary
      @tax_withholding.health_insurance = tax_withholding.health_insurance
      @tax_withholding.nursing_insurance = tax_withholding.nursing_insurance
      @tax_withholding.pension = tax_withholding.pension
      @tax_withholding.unemployment_insurance = tax_withholding.unemployment_insurance
      @tax_withholding.taxables = tax_withholding.taxables
      @tax_withholding.dependents = tax_withholding.dependents
      @tax_withholding.calculated_tax_amount = tax_withholding.calculated_tax_amount
      @tax_withholding.adjustment = tax_withholding.adjustment
      @tax_withholding.net_collection = tax_withholding.net_collection
      @tax_withholding.resident_tax = tax_withholding.resident_tax
      @tax_withholding.bonus = tax_withholding.bonus
      @tax_withholding.social_insurance = tax_withholding.social_insurance
      @tax_withholding.date = Date.today
    end

    @reports = Report.where(["driver_id = ? AND started_at BETWEEN ? AND ?",
                             params[:driver_id],
                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-1 00:00}"),
                             Time.zone.parse("#{params[:year].to_s}-#{params[:month].to_s}-#{Date.new(params[:year].to_i, params[:month].to_i, -1).day.to_s} 23:59}"),
                            ])

    @tax_withholding.working_days = @reports.size

    working_hours = 0
    @reports.each do |report|
      working_hours += report.finished_at - report.started_at
    end
    rest_hours = 0
    rests = Rest.where(["report_id IN (?)", @reports.pluck(:id)])
    rests.each do |rest|
      rest_hours += rest.ended_at - rest.started_at
    end
    @tax_withholding.working_hours = (working_hours - rest_hours).divmod(60*60)[0]

    @tax_withholding.base_salary = @reports.size * 5000

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tax_withholding }
    end
  end

  # GET /tax_withholdings/:driver_id/:year
  # GET /tax_withholdings/:driver_id/:year.json
  def index
    title = "所得税源泉徴収簿 #{@reports[0].started_at.strftime('%Y%0m')}_(#{@reports[0].driver.name})" rescue "所得税源泉徴収簿"

    @driver = Driver.find(params[:driver_id])

    @tax_withholdings = TaxWithholding.where(["driver_id = ? AND date BETWEEN ? AND ?",
                                             params[:driver_id],
                                             Date.new(params[:year].to_i, 1, 1),
                                             Date.new(params[:year].to_i, 12, 31)
                                            ])
    @tax_withholding_hash = Hash.new
    @salary_subtotals = Hash.new
    @social_insurence_subtotals = Hash.new
    @total_hash = Hash.new do |hash, key|
      hash[key] = 0
    end

    @tax_withholdings.each do |t|
      @tax_withholding_hash.store(t.date.month, t)
      @salary_subtotals.store(t.date.month, t.base_salary + t.percentage_pay + t.holiday_pay + t.night_pay + t.extra_pay + t.no_absence_pay + t.no_accident_pay + t.long_service_pay + t.real_salary)
      @social_insurence_subtotals.store(t.date.month, t.health_insurance + t.nursing_insurance + t.pension + t.unemployment_insurance)
      @total_hash[:working_days] += t.working_days
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tax_withholding_hash }
      format.pdf do
        # render :pdf => title, :orientation => "Landscape", :encoding => "UTF-8"
        render :pdf => title, :encoding => "UTF-8"
      end
    end
  end

  # POST /tax_withholdings
  # POST /tax_withholdings.json
  def create
    @tax_withholding = TaxWithholding.new(params[:tax_withholding])

    respond_to do |format|
      if @tax_withholding.save
        format.html { redirect_to "#{tax_withholdings_path}/#{@tax_withholding.driver_id}/#{@tax_withholding.date.year}", notice: t("activerecord.models.tax_withholding") + t("message.created") }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /tax_withholdings/1
  # PUT /tax_withholdings/1.json
  def update
    respond_to do |format|
      if @tax_withholding.update_attributes(params[:tax_withholding])
        format.html { redirect_to "#{tax_withholdings_path}/#{@tax_withholding.driver_id}/#{@tax_withholding.date.year}", notice: t("activerecord.models.tax_withholding") + t("message.updated") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /tax_withholdings/1
  # DELETE /tax_withholdings/1.json
  def destroy
    @tax_withholding.destroy

    respond_to do |format|
      if @tax_withholding.report
        redirect_path = report_path(@tax_withholding.report)
      else
        redirect_path = "#{reports_path}/#{@tax_withholding.date.year}/#{@tax_withholding.date.month}/#{@tax_withholding.date.day}"
      end
      format.html { redirect_to redirect_path, notice: t("activerecord.models.tax_withholding") + t("message.created") }
      format.json { head :ok }
    end
  end

  private
  def set_tax_withholding
    @tax_withholding = TaxWithholding.find(params[:id])
  end

  def authenticate_owner
    redirect_to root_path if @tax_withholding.driver.user != current_user
  end

  def prepare_options
    @credit_options = [[t("views.tax_withholding.credit_sales"), t("views.tax_withholding.credit_sales")],
                      [t("views.tax_withholding.credit_advance"), t("views.tax_withholding.credit_advance")],
                      [t("views.tax_withholding.credit_receivable"), t("views.tax_withholding.credit_receivable")]]
  end
end
