class AlbumsController < ApplicationController
  def search
  end

  def show
    @album = Album.find(params[:id])
    @photos = Photo.where(date_taken: @album[:start]..@album[:end])
    @photos = @photos.order(:date_taken)
    @photos = @photos.where(make: @album[:make]) unless @album[:make].nil? or @album[:make]==""
    @photos = @photos.where(model: @album[:model]) unless @album[:model].nil? or @album[:model]==""
    @photos = @photos.joins(:location).where('locations.country=?', @album[:country]) unless @album[:country].nil? or @album[:country]==""
    @photos = @photos.joins(:location).where('locations.city=?', @album[:city]) unless @album[:city].nil? or @album[:city]==""
    @photos = @photos.page params[:page]
    render "photos/index"
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
      format.html { redirect_to albums_url, notice: 'Almum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  
  
  
  private
  
  def album_params
    params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city)
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
  end
  
  
end
