module Api
class UserInfosController < ApplicationController
  
  # GET /user_infos
  # GET /user_infos.json
  def index
    @user_infos = UserInfo.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @user_infos }
    # end
    render json: @user_infos
  end

  # GET /user_infos/1
  # GET /user_infos/1.json
  def show
    @user_info = UserInfo.find(params[:id])

    render json: @user_info
  end

  # GET /user_infos/new
  # GET /user_infos/new.json
  def new
    @user_info = UserInfo.new

    render json: @user_info
  end

  # POST /user_infos
  # POST /user_infos.json
  def create
    @user_info = UserInfo.new(user_info_params)

    if @user_info.save
      render json: @user_info, status: :created
    else
      render json: @user_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_infos/1
  # PATCH/PUT /user_infos/1.json
  def update
    @user_info = UserInfo.find(params[:id])

    if @user_info.update_attributes(user_info_params)
      head :no_content
    else
      render json: @user_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_infos/1
  # DELETE /user_infos/1.json
  def destroy
    @user_info = UserInfo.find(params[:id])
    @user_info.destroy

    head :no_content
  end

  def user_info_params
  	params.require(:user_info).permit(:name, :phone_number, :content_id)
  end
end

end