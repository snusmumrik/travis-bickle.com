class NotificationsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  before_filter :prepare_options, :only => [:new, :edit, :create, :update]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.where(["user_id = ? AND deleted_at IS NULL", current_user.id])
    if params[:notification]
      @notifications = @notifications.name_matches params[:notification][:text]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @notification }
    end
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(params[:notification])
    @notification.user_id = current_user.id

    respond_to do |format|
      if @notification.save
        push_notification(@notification.car.device_token, @notification.text) if @notification.car.device_token
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render json: @notification, status: :created, location: @notification }
      else
        format.html { render action: "new" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.json
  def update
    @notification = Notification.find(params[:id])
    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to notification_path(@notification), notice: 'Notification was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
    push_notification(@notification.car.device_token, @notification.text)
  end

  private
  def authenticate_owner
    @notification = Notification.find(params[:id])
    redirect_to notifications_path if @notification.user_id != current_user.id
  end

  def prepare_options
    cars = Car.where(["user_id = ? AND deleted_at IS NULL", current_user.id]).all
    @car_options = []
    cars.each do |car|
      @car_options << [car.name, car.id]
    end
  end

  def push_notification(device_token, text)
    pusher = Grocer.pusher(certificate: "#{Rails.root}/doc/apns-dev.pem",      # required
                           # passphrase:  "",                       # optional
                           # gateway:     localhost, # test
                           gateway:     "gateway.sandbox.push.apple.com", # develpment
                           # gateway:     "gateway.push.apple.com", # production
                           port:        2195,                     # optional
                           retries:     3                         # optional
                           )
    notification = Grocer::Notification.new(device_token: device_token,
                                            alert:        text,
                                            badge:        0,
                                            sound:        "siren.aiff",         # optional
                                            expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
                                            identifier:   1234                  # optional
                                            )

    pusher.push(notification)
  end
end
