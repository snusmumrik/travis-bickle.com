class Api::MetersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # GET /api/meters
  # GET /api/meters.json
  def index
    respond_to do |format|
      if params[:car_id] && params[:year] && params[:month] && params[:day] && params[:hour] && params[:minute]
        date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, params[:minute].to_i)

        @meter = Meter.joins(:report => :car).where(["reports.car_id = ? AND reports.started_at < ?",
                                                    params[:car_id],
                                                    date]).order("reports.started_at DESC").first
        if @meter
          format.json { render json: {:meter => @meter}, status: :created}
        else
          format.json { render json:{ :error => "Not Acceptable:meters#show", :status => 406 } }
        end
      end
    end
  end
end
