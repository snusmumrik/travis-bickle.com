class Api::NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # Called from web
  # GET /api/notifications
  # GET /api/notifications.json
  def index
    @notifications = Notification.find_by_sql(["SELECT notifications.*, cars.name FROM notifications INNER JOIN cars ON cars.id = notifications.car_id WHERE (notifications.deleted_at IS NULL AND notifications.user_id = ? AND notifications.sent_at IS NULL)", current_user.id])

    if @notifications.nil?
      respond_to do |format|
        format.json { render json:{ :error => "Not Acceptable:notifications#index", :status => 406 } }
      end
    else
      @notifications.each do |notification|
        notification.update_attribute(:sent_at, DateTime.now)
      end

      respond_to do |format|
        format.json { render json: @notifications }
      end
    end
  end

  # Called from app
  # PUT /api/notifications/1
  # PUT /api/notifications/1.json
  def update
    @notification = Notification.joins(:car).where(["device_token = ? AND notifications.id = ?", params[:device_token], params[:id]]).first
    if @notification
      @notification.canceled_at =  DateTime.now if params[:cancel]
      @notification.accepted_at =  DateTime.now if params[:accept]

      respond_to do |format|
        if @notification.save
          format.json { render json: @notification }
        else
          format.json { render json: @notification.errors }
        end
      end
    else
      respond_to do |format|
        format.json { render json:{ :error => "Not Acceptable:notifications#update", :status => 406 } }
      end
    end
  end
end
