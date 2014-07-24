module Api
class ContentsController < ApplicationController
  
  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @contents }
    # end
    render json: @contents.to_json(:include => [:photos, :user_info])
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])

    render json: @content.to_json(:include => [:photos, :user_info])
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    @content = Content.new

    render json: @content
  end

  # POST /contents
  # POST /contents.json
  def create
    photo_list = content_params.delete(:photos)
    user_info = content_params.delete(:user_info)
    @content = Content.create(content_params.except(:photos, :user_info))
    if user_info
      @content.create_user_info(user_info)
    end
    if photo_list.each do |photo|
         @content.photos.create(photo)
      end
    end
    if @content.save
      render json: @content.to_json(:include => [:photos, :user_info]), status: :created
    else
      render json: @content.errors, status: :unprocessable_entity
    end

    @content.broadcast
  end

  def rebroadcast
    @content = Content.find(params[:id])
    if @content.valid?
      @content.broadcast
      render json: "Successful" , status: 200
    else
      render json: @content.errors
    end
  end

  def find_nearby
    latitude = params[:latitude]
    longitude = params[:longitude]
    @content = Content.near([latitude, longitude], 10, units: :km).order("distance")
    paginate json: @content.includes(:photos, :user_info), per_page: 10
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    if @content.update_attributes(content_params)
      head :no_content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    head :no_content
  end

  def content_params
    params.require(:content).permit(:device_token, :audio_url, :longitude, :latitude, :photos => [:photo_url, :timeline], :user_info => [:name, :phone_number])
  end
end

end