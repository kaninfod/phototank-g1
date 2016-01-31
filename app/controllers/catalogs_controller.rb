
class CatalogsController < ApplicationController



  def index
    @catalogs = Catalog.order(:name).page params[:page]
  end
  def edit
    @catalog = Catalog.find(params[:id])
  end

  def update
    @catalog = set_catalog
    respond_to do |format|
      if @catalog.update(catalog_params)
        format.html { redirect_to action: 'index', notice: 'Catalog was successfully updated.' }
        format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @catalog = Catalog.new
  end

  def create
    @catalog = Catalog.new(catalog_params)
    respond_to do |format|
      if @catalog.save
        format.html { redirect_to action: 'index', notice: 'Catalog was successfully created.' }
        format.json { render :show, status: :created, location: @catalog }
      else
        format.html { render :new }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end    
  end

  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy
    respond_to do |format|
      format.html { redirect_to catalogs_url, notice: 'Caatalog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  

  def show
    @catalog = Catalog.find(params[:id])
    @photos = Catalog.find(params[:id]).photos.page params[:page]
    @bucket = session[:bucket]
  end
  

  def import

    @catalog = Catalog.find(params[:id])
    watch_path = @catalog.watch_path

    if File.exist?(watch_path) 
      insert_time = Time.now
      Dir.glob("#{watch_path}/*.jpg").each do |jpeg_file|
        
        if File.file?(jpeg_file)
          @photo = Photo.new
          @photo.catalogs << @catalog
          if @photo.populate_from_file jpeg_file
            @photo.save
          end
        end
      end
      
      @photos = Catalog.find(params[:id]).photos.page params[:page]
      @bucket = session[:bucket]
      
    else 
      logger.debug "Watch filepath did not exist"  
    end
  end

  private
    
    def set_catalog
      Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:name, :path, :default, :watch_path)
    end
end
