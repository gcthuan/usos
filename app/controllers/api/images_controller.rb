module Api
class ImagesController < ApplicationController
  
  # GET /images
  # GET /images.json
  def index
    @images = Image.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @images }
    # end
    render json: @images
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    render json: @image
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new

    render json: @image
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    if @image.save
      @message = Message.find(@image.message_id)
      @message.images << @image
      render json: @image, status: :created
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end


  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    head :no_content
  end

  def image_params
  	params.require(:image).permit(:small_image_url, :medium_image_url, :normal_image_url, :message_id)
  end
end

end