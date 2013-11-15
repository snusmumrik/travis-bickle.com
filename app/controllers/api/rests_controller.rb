class Api::RestsController < ApplicationController
  before_filter :authenticate_token
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /api/rests
  # POST /api/rests.jsonb
  def create
    @rest = Rest.new(:report_id => params[:report_id],
                     :latitude => params[:latitude],
                     :longitude => params[:longitude],
                     :address => params[:address],
                     :started_at => Time.now()
                     )

    respond_to do |format|
      if @rest.save
        @json = Hash[:rest => {
                       :id => @rest.id,
                       :report_id => @rest.report_id,
                       :latitude => @rest.latitude,
                       :longitude => @rest.longitude,
                       :address => @rest.address
                     }]
        format.json { render json: @json, status: :created, location: @json }
      else
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/rests/1
  # PUT /api/rests/1.json
  def update
    @rest = Rest.where(["id = ? AND report_id = ?" , params[:id], params[:report_id]]).first

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
        format.json { render json:{ :error => "Not Acceptable:rests#update", :status => 406 } }
      end
    end
  end

  private
  def authenticate_token
    @car = Car.where(["device_token = ?", params[:device_token]]).first
    @report = Report.where(["id = ? AND car_id = ?", params[:report_id], @car.try(:id)]).first
    render json:{ :error => "Not Acceptable:rests#authenticate_token", :status => 406 } unless @report
  end
end