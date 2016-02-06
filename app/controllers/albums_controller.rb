class AlbumsController < ApplicationController
  def grid 
    @photos = Photo.all
    @bucket = session[:bucket]
  end

  def show
    @album = Album.find(params[:id])
    @photos = @album.photos
    @photos = @photos.page params[:page]
    @bucket = session[:bucket]
  end

  def index
    @albums = Album.order(:created_at).page params[:page]
  end

  def edit
    @album = Album.find(params[:id])
    prep_form
  end
  
  def update

    @album = Album.find(params[:id])
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # GET /photos/new
  def new
    @album = Album.new
    prep_form
  end
  
  def create

    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end    
  end
  
  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  
  
  def select
    if request.post?
      if not params[:optionsRadios].blank?
        
        album = Album.find(params[:optionsRadios].to_i)
        a = (album.photo_ids + session[:bucket]).uniq{|x| x}
        album.photo_ids = a
        if album.save
          redirect_to '/albums'
        end
      end
    else
      @albums = Album.all.page params[:page]
    end
    
    
  end
  
  
  private
  
    def album_params
      params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids)
    end
  
    def prep_form
      @countries = Location.select(:country).distinct.map{ |c| [c.country] }
      @countries = @countries.unshift([''])

      @cities = Location.select(:city).distinct.map{ |c| [c.city] }
      @cities = @cities.unshift([''])

      @makes = Photo.select(:make).distinct.map{ |c| [c.make] }
      @makes = @makes.unshift([''])

      @models = Photo.select(:model).distinct.map{ |c| [c.model] }
      @models = @models.unshift([''])
    
      @bucket = session[:bucket]
    end
  
  
end
