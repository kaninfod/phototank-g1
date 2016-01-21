class PhotosController < ApplicationController
  #before_action :set_photo, only: [:image, :display, :show, :edit, :update, :destroy]


  
  def image
    @photo = set_photo
    localpath = @photo.default_instance
    
    if params[:size] == "original"
      filepath = File.join(localpath, @photo.original_filename)
    elsif params[:size] == "large"
      filepath = File.join(localpath, @photo.large_filename)
    elsif params[:size] == "small"
      filepath = File.join(localpath, @photo.small_filename)
    else
      filepath = File.join(localpath, @photo.medium_filename)    
    end
    
    send_file filepath, :disposition => 'inline'
  end
  
  # GET /photos
  # GET /photos.json
  def index

    @photos = Photo.order(:date_taken).page params[:page]
    
    
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = set_photo
    @photoimage = '/photos/' + @photo.id.to_s + '/image'
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
    @photo = set_photo
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    @photo = set_photo
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = set_photo    
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:filename, :date_taken, :path, :file_thumb_path, :file_extension, :file_size, :location_id, :make, :model, :original_height, :original_width, :longitude, :latitude)
    end
end
