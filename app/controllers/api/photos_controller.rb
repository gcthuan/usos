module Api
class PhotosController < ApplicationController
  
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @photos }
    # end
    render json: @photos
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])

    render json: @photo
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    render json: @photo
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      render json: @photo, status: :created
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end


  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    head :no_content
  end

  def photo_params
  	params.require(:photo).permit(:photo_url, :timeline, :content_id)
  end
end

end