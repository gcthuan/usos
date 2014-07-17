
module Api
class MessagesController < ApplicationController
  
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @messages }
    # end
    render json: @messages
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    render json: @message.to_json(:include => [:images])
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    render json: @message
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    if @message.save
      @user = User.find(@message.user_id)
      @user.messages << @message
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    head :no_content
  end

  def find_nearby_devices
    nearby_users = Array.new
    #current_message = Message.where(latitude: message_params[:latitude], longtitude: message_params[:longtitude])
    current_message = Message.find(params[:id])
    User.all.each do |user|
      if !user.messages.include? current_message 
        d = distance [current_message.latitude, current_message.longtitude], [user.latitude, user.longtitude]
        user.update_attribute :distance, d
        if d <= 5000
          nearby_users << user
        end
      end
    end
    nearby_users.sort! { |a, b| a.distance <=> b.distance }
    nearby_devices = Array.new
    nearby_users.each do |user|
      nearby_devices << user.device_id
    end
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(nearby_devices[0..49], data)
    render json: nearby_devices[0..49]
  end

  def find_all_devices
    all_devices = User.pluck(:device_id)
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(all_devices, data)
    render json: all_devices
  end

  def find_one_device
    device = params[:device_id]
    message = Message.find(params[:id])
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(device, data)
    render json: device
  end

  private

  def distance(a, b)
    if !(a.nil? || b.nil?)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg

    lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin(Math.sqrt(a))

    rm * c # Delta in meters
    end
  end

  def message_params
    params.require(:message).permit(:audio_url, :audio_length, :user_id, :longtitude, :latitude, :message)
  end

end

end