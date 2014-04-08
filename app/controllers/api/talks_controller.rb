# -*- coding: utf-8 -*-
class Api::TalksController < InheritedResources::Base
  before_filter :authenticate_token
  after_filter :send_push_notifications, :only => :create
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

# GET /api/talks
  # GET /api/talks.json
  def index
    if @car
      @talk = Talk.where(["receiver_car_id = ? and received IS NULL", @car.id]).first
    elsif @user
      @talk = Talk.where(["receiver_user_id = ? and received IS NULL", @user.id]).first
    end

    if @talk
      @talk.update_attribute(:received, true)
      respond_to do |format|
        format.json { send_file @talk.audio.path, :type => "audio/mp3"}
      end
    else
      respond_to do |format|
        format.json { render json: {:error => "no talk"}}
      end
    end
  end

  # GET /api/talks/1
  # GET /api/talks/1.json
  def show
    @talk = Talk.find(params[:id])

    respond_to do |format|
      # format.json { render json: {:talk => @talk, :audio => @talk.audio} }
      format.json { send_file @talk.audio.path, :type => "audio/mp3"}
    end
  end

  # POST /api/talks
  # POST /api/talks.json
  def create
    @talk = Talk.new(params)
    if params[:sender_car_id]
      car = Car.find(params[:sender_car_id])
      @talk.receiver_user_id = car.user_id
    end

    respond_to do |format|
      if @talk.save(:validate => false)
        system("ffmpeg -y -i '#{Rails.root}/app/assets/audios/talks/#{@talk.id}/original/audio.caf' -acodec libmp3lame -ab 256 '#{Rails.root}/app/assets/audios/talks/#{@talk.id}/original/audio.mp3'")
        system("rm '#{Rails.root}/app/assets/audios/talks/#{@talk.id}/original/audio.caf'")
        @talk.update_attribute(:audio_file_name, "audio.mp3")
        format.json { render json: {:talk => @talk} }
      else
        format.json { render json: {:error => "Talk creation failed."} }
      end
    end
  end

  private
  def authenticate_token
    @car = Car.where(["device_token = ? AND deleted_at IS NULL", params[:device_token]]).order("updated_at DESC").first if params[:device_token]
    user = User.where(["email = ? AND deleted_at IS NULL", params[:email]]).first if params[:email]
    @user = user if params[:password] && user.valid_password?(params[:password])
    render json:{ :error => "Not Acceptable:talks#authenticate_token", :status => 406 } unless @car || @user
  end

  def send_push_notifications
    if @talk.receiver_user_id && @user = User.find(@talk.receiver_user_id)
      @user.device_tokens.each do |device_token|
        push_notification(device_token)
      end
    end

    if @talk.receiver_car_id && @car = Car.find(@talk.receiver_car_id)
      push_notification(@car.device_token)
    end
  end

  def push_notification(device_token)
    pusher = Grocer.pusher(# certificate: "#{Rails.root}/doc/aps_certificate_talk_pro.pem",      # production
                           certificate: "#{Rails.root}/doc/aps_certificate_talk_dev.pem",      # development
                           # passphrase:  "",                       # optional
                           # gateway:     localhost, # test
                           # gateway:     "gateway.push.apple.com", # production
                           gateway:     "gateway.sandbox.push.apple.com", # develpment
                           port:        2195,                     # optional
                           retries:     3                         # optional
                           )
    notification = Grocer::Notification.new(device_token: device_token,
                                            alert:        "メッセージを受信しました",
                                            badge:        0,
                                            # sound:        "siren.aiff",         # optional
                                            expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
                                            # identifier:   1234,                 # optional
                                            custom: {
                                            })
    pusher.push(notification)
  end
end
