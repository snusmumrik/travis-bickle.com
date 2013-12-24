class Api::ReportsController < ApplicationController
  before_filter :authenticate_token, :except => :create
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /api/reports/1
  # GET /api/reports/1.json
  def show
    respond_to do |format|
      if @report
        format.json { render json: @report, status: :created, location: @report }
      else
        format.json { render json:{ :error => "Not Acceptable:reports#show", :status => 406 } }
      end
    end
  end

  # POST /api/reports
  # POST /api/reports.json
  def create
    @car = Car.find(params[:car_id])
    @car.update_attributes({ :device_token => params[:device_token],
                             :updated_at => Time.now()})

    @report = Report.where(["car_id = ? AND driver_id = ? AND finished_at IS NULL", params[:car_id], params[:driver_id]]).first

    if @report
      @report.update_attribute(:updated_at, Time.now())
      respond_to do |format|
        format.json { render json: @report }
      end
    else
      @report = Report.new(:driver_id => params[:driver_id],
                           :car_id => params[:car_id],
                           :started_at => DateTime.now())

      respond_to do |format|
        if @report.save
          format.json { render json: @report, status: :created, location: @report }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /api/reports/1
  # PUT /api/reports/1.json
  def update
    if @report
      @last_meter = @report.last_meter

      if meter = Meter.where(["report_id = ?", @report.id]).first
        meter.update_attributes({ :report_id => @report.id,
                                  :meter => params[:meter].presence || 0,
                                  :mileage => params[:mileage].presence || 0,
                                  :riding_mileage => params[:riding_mileage].presence || 0,
                                  :riding_count => @last_meter.riding_count + params[:riding_count].to_i,
                                  :meter_fare_count => @last_meter.meter_fare_count + params[:meter_fare_count].to_i })
      else
        Meter.create( :report_id => @report.id,
                      :meter => params[:meter],
                      :mileage => params[:mileage],
                      :riding_mileage => params[:riding_mileage],
                      :riding_count => @last_meter.riding_count + params[:riding_count].to_i,
                      :meter_fare_count => @last_meter.meter_fare_count + params[:meter_fare_count].to_i
                      )
      end

      credit = params[:cash].to_i + params[:ticket].to_i + params[:account_receivable].to_i + params[:fuel_cost].to_i + params[:advance].to_i
      debit = params[:sales].to_i + params[:extra_sales].to_i
      if debit - credit >= 0
        deficiency_account = debit - credit
        surplus_funds = 0
      elsif credit - debit > 0
        surplus_funds = credit - debit
        deficiency_account = 0
      end

      @report.update_attributes({ :mileage => params[:mileage].to_i - @last_meter.mileage,
                                  :riding_mileage => params[:riding_mileage].to_i - @last_meter.riding_mileage,
                                  :riding_count => params[:riding_count],
                                  :meter_fare_count => params[:meter_fare_count],
                                  :fuel_cost => params[:fuel_cost].presence || 0,
                                  :ticket => params[:ticket].presence || 0,
                                  :account_receivable => params[:account_receivable].presence || 0,
                                  :cash => params[:cash].presence || 0,
                                  :sales => params[:sales].presence || 0,
                                  :extra_sales => params[:extra_sales].presence || 0,
                                  :surplus_funds => surplus_funds,
                                  :deficiency_account => deficiency_account,
                                  :finished_at => DateTime.now})


      respond_to do |format|
        if @report.save
          format.json { render json: @report, status: :created, location: @report }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{ :error => "Not Acceptable:reports#update", :status => 406 } }
      end
    end
  end

  private
  def authenticate_token
    @car = Car.where(["device_token = ? AND deleted_at IS NULL", params[:device_token]]).order("updated_at DESC").first
    @report = Report.where(["id = ? AND car_id = ?", params[:id], @car.id]).first if @car
    render json:{ :error => "Not Acceptable:reports#authenticate_token", :status => 406 } unless @report
  end
end
