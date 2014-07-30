module Api
class DevicesController < ApplicationController
  
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @devices }
    # end
    render json: @devices
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    render json: @device
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    @device = Device.new

    render json: @device
  end

  # POST /devices
  # POST /devices.json
  def create
    if @device = Device.find_by_uid(device_params[:uid])
      @device.update_attributes(device_params)
    else
      puts device_params
      @device = Device.create(device_params)
    end
    render json: @device, status: 200
  end

  def reload_token
    @device = Device.find(params[:uid])
    if @device.update_attributes(device_params)
      render json: @device, status: 200
    else

    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    head :no_content
  end

  def device_params
  	params.require(:device).permit(:uid, :device_token, :latitude, :longitude)
  end
end

end