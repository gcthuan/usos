module Api
class UsersController < ApplicationController
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @users }
    # end
    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user.to_json(:include => [:messages])
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    existed_user = User.where(device_id: user_params[:device_id])
    if existed_user.blank?
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: existed_user
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  def user_params
  	params.require(:user).permit(:fullname, :device_imei, :device_id, :phone, :longtitude, :latitude)
  end
end

end