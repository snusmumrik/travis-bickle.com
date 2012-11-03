class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, :except => :index

  # GET /users
  # GET /users.json
  def index
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # # GET /users/new
  # # GET /users/new.json
  # def new
  #   @user = User.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @user }
  #   end
  # end

  # GET /users/1/edit
  def edit
  end

  # # POST /users
  # # POST /users.json
  # def create
  #   @user = User.new(params[:user])

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render json: @user, status: :created, location: @user }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @image = Image::UserImage.new(params[:image]) if params[:image]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.images << @image if @image
        format.html { redirect_to user_path(current_user.username), notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

  protected
  def find_user
    @user = User.where(["username = ?", params[:id]]).first || User.find(params[:id])
  end
end
