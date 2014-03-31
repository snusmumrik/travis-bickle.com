class TalksController < InheritedResources::Base
  # before_filter :authenticate_user!
  # before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]
  # before_filter :prepare_options, :only => [:new, :edit, :create, :update]

  # # GET /talks
  # # GET /talks.json
  # def index
  #   @title += " | #{t('activerecord.models.talk')}"
  #   @talks = Talk.where(["user_id = ?", current_user.id]).order("created_at DESC").page params[:page]

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.js # index.js.erb
  #     format.json { render json: @talk }
  #   end
  # end

  # # POST /talks
  # # POST /talks.json
  # def create
  #   @talk = Talk.new(params[:talk])
  #   @talk.user_id = current_user.id

  #   respond_to do |format|
  #     if @talk.save
  #       push_talk(@talk.id, @talk.car.device_token, @talk.text) if @talk.car.device_token
  #       format.html { redirect_to talks_path, notice: t("activerecord.models.talk") + t("message.created") }
  #       format.json { render json: @talk, status: :created, location: @talk }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @talk.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PUT /talks/1
  # # PUT /talks/1.json
  # def update
  #   @talk = Talk.find(params[:id])
  #   respond_to do |format|
  #     if @talk.update_attributes(params[:talk])
  #       format.html { redirect_to talks_path, notice: t("activerecord.models.talk") + t("message.updated") }
  #       format.json { head :ok }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @talk.errors, status: :unprocessable_entity }
  #     end
  #   end
  #   push_talk(@talk.id, @talk.car.device_token, @talk.text)
  # end

  # private
  # def authenticate_owner
  #   @talk = Talk.find(params[:id])
  #   redirect_to talks_path if @talk.user_id != current_user.id
  # end

  # def prepare_options
  #   cars = Car.where(["user_id = ? AND deleted_at IS NULL", current_user.id]).all
  #   @car_options = []
  #   cars.each do |car|
  #     @car_options << [car.name, car.id]
  #   end
  # end
end
