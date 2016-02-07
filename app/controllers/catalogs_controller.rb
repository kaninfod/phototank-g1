
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
    @catalog_options = [['Local','LocalCatalog'], ['Dropbox','DropboxCatalog']]
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
    if params.has_key?(:viewmode)
      @view = params[:viewmode]
    else
      @view = 'grid'
    end
    @bucket = session[:bucket]
        
    @catalog = Catalog.find(params[:id])
    @photos = Catalog.find(params[:id]).photos.page params[:page]

  end
  

  def import

    @catalog = Catalog.find(params[:id])
    watch_path = @catalog.watch_path

    if File.exist?(watch_path)
      Resque.enqueue(Importer, watch_path, @catalog.id) 
      @photos = Catalog.find(params[:id]).photos.page params[:page]
      @bucket = session[:bucket]
    else 
      logger.debug "Watch filepath did not exist"  
    end
  end
  
  def manage


    if params[:album_id]
      Catalog.find(params[:id]).add_from_album(params[:album_id])
    elsif params[:catalog_id]
      Catalog.find(params[:id]).clone_from_catalog(params[:catalog_id])
    end

    
    
    @catalog_options = [['Local','LocalCatalog'], ['Dropbox','DropboxCatalog']]
    @catalog = Catalog.find(params[:id])
  end
  
  private
    
    def set_catalog
      Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:name, :path, :default, :watch_path, :type)
    end
end
