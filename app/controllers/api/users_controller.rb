class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /api/users/signin
  # POST /api/users/signin.json
  def signin
    respond_to do |format|
      @user = User.where(["email = ? AND deleted_at IS NULL", params[:email]]).first
      if @user && @user.valid_password?(params[:password])
        unless DeviceToken.where(["user_id = ? AND device_token =?", @user.id, params[:device_token]]).first
          DeviceToken.create(:user_id => @user.id, :device_token => params[:device_token])
        end

        @cars = Car.where(["user_id = ?", @user.id]).order("name").all
        format.json { render json: {:user => @user, :cars => @cars} }
      else
        format.json { render json:{:error => "signin failed" } }
      end
    end
  end
end
