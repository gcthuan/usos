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
    render json: @contents.to_json(:include => [:photos, :user_info], :except => [:ignored_list])
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])

    render json: @content.to_json(:include => [:photos, :user_info], :except => [:ignored_list])
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
    local_time = @content.created_at + 7.hours
    @content.update_attribute :local_time, local_time
    if user_info
      @content.create_user_info(user_info)
    end
    if photo_list.each do |photo|
         @content.photos.create(photo)
      end
    end
    if @content.save
      render json: @content.to_json(:include => [:photos, :user_info], :except => [:ignored_list]), status: :created
    else
      render json: @content.errors, status: :unprocessable_entity
    end

    @content.broadcast
  end

  def rebroadcast
    @content = Content.find(params[:id])
    if @content.rebroadcast_status == false
      @content.update_attribute :ignored_list, []
      @content.broadcast
      @content.update_attribute :rebroadcast_status, true
    end
    render json: @content.to_json(:include => [:photos, :user_info], :exclude => [:ignored_list]), status: 200
  end

  def find_nearby
    latitude = params[:latitude]
    longitude = params[:longitude]
    if params[:page].nil?
      page = 1
    else
      page = params[:page]
    end
    @contents = Content.near([latitude, longitude], 5, units: :km)
    first = (page.to_i - 1) * 10
    last = first + 9
    @nearby_contents = @contents[first..last]
    if @nearby_contents.nil?
      render json: "No content found", status: 204
    else
      render json: @nearby_contents.select { |content| content.status == 'available' }.to_json(:include => [:photos, :user_info], :except => [:ignored_list]), status: 200
    end
  end

  def push
    device_token = params[:device_token]
    if @content = Content.find(params[:id])
      APNS.send_notification(device_token, alert: "#{@content.user_info.name} needs your help!", sound: 'default', badge: 1, :other => {:id => @content.id})
      render json: "OK", status: 200
    else
      render json: "Content not found", status: 404
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    @content.update_attribute :status, "unavailable"

    #if @content.update_attributes(content_params)
    #  head :no_content
    #else
    #  render json: @content.errors, status: :unprocessable_entity
    #end
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