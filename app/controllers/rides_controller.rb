# -*- coding: utf-8 -*-
class RidesController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :set_options, :only => [:new, :edit, :create, :update]
  after_filter :check_balance, :only => [:create, :update]

  # GET /rides
  # GET /rides.json
  def index
    redirect_to root_path
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

  # GET /rides/1/edit
  def edit
    @ride = Ride.find(params[:id])
    @report = @ride.report
  end

  # POST /rides
  # POST /rides.json
  def create
    @ride = Ride.new(params[:ride])
    @report = Report.find(params[:ride][:report_id])

    respond_to do |format|
      if @ride.save
        format.html { redirect_to @ride.report, notice: t("activerecord.models.ride") + t("message.created") }
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
        format.html { redirect_to @ride.report, notice: t("activerecord.models.ride") + t("message.updated") }
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
      format.html { redirect_to @ride.report }
      format.json { head :ok }
    end
  end

  private
  def set_options
    @segment_options = Array.new
    segments = ["現金", "Edy",  "チケット（未収）", "チケット（前受）"]
    segments.each_with_index do |segment, i|
      @segment_options << [segment, i]
    end
  end

  def check_balance
    @report = @ride.report
    @report.cash = @report.rides.where("segment = 0").sum(:fare)
    @report.edy = @report.rides.where("segment = 1").sum(:fare)
    @report.ticket = @report.rides.where("segment = 2").sum(:fare)
    @report.advance = @report.rides.where("segment = 3").sum(:fare)
    @report.sales = @report.rides.sum(:fare)

    credit = @report.cash + @report.ticket + @report.account_receivable + @report.fuel_cost + @report.advance
    debit = @report.sales + @report.extra_sales
    if debit - credit >= 0
      @report.deficiency_account = debit - credit
      @report.surplus_funds = 0
    elsif credit - debit > 0
      @report.surplus_funds = credit - debit
      @report.deficiency_account = 0
    end
    @report.save
  end
end
