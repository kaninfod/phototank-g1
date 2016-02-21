class CatalogsController < ApplicationController
  def index
    @catalogs = Catalog.order(:id).page params[:page]
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
        format.html { redirect_to action: 'manage', id:@catalog, notice: 'Catalog was successfully created.' }
        format.json { render :show, status: :created, location: @catalog }
      else
        format.html { render :new }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    byebug
    @catalog = Catalog.find(params[:id])
    @catalog.destroy
    respond_to do |format|
      format.html { redirect_to :index, notice: 'Catalog was successfully destroyed.' }
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

  if request.post?
    case params['import_action']
    when 'master'
      import_to_master
    when 'local'
      import_to_local
    end

    redirect_to action: "show", id: params[:id]
  else
    @catalog = Catalog.find(params[:id])
    if @catalog.sync_from_catalog
      @sync_from_catalog = Catalog.find(@catalog.sync_from_catalog)
    else
      @sync_from_albums = Album.find(@catalog.sync_from_albums)
    end
  end
end

  def manage
    @catalog = Catalog.find(params[:id])

    if request.post?
      catalog = params.permit(:name, :type, :path)
      case params[:type]
      when "MasterCatalog"
        watch_path =[]
        params.each do |k, v|
          watch_path.push(v) if (k.include?('wp_') & not(v.blank?))
        end
        catalog['watch_path'] = watch_path

      when "LocalCatalog"
        catalog = params.permit(:name, :type, :path)
        if params[:sync_from] == "catalog"
          catalog['sync_from_catalog'] = params[:sync_from_catalog_id]
          catalog['sync_from_albums'] = nil
        elsif params[:sync_from] == "album"
          albums = []
          params.each do |k, v|
            albums.push(v) if (k.include?('sync_from_album_id_') & not(v.blank?))
          end
          catalog['sync_from_albums'] = albums
          catalog['sync_from_catalog'] = nil
        end
      end

      if @catalog.update(catalog)
        redirect_to action: 'index', notice: 'Catalog was successfully updated.'
      end
    else #request is GET
      @catalog_options = [['Master','MasterCatalog'],['Local','LocalCatalog'], ['Dropbox','DropboxCatalog']]
      if @catalog.sync_from_albums.blank?
        @sync_from="catalog"
      else
        @sync_from="album"
      end
    end

  end

  def get_catalog
    render :json => Catalog.find(params[:id]).to_json
  end

  private
  def import_to_master
    begin
      @catalog = Catalog.find(params[:id])
      @catalog.watch_path.each do |path|
        if File.exist?(path)
          @catalog.import(path)
        else
          logger.debug "path #{path} did not exist"
        end
      end
      return true
    rescue Exception => e
      raise e
    end
  end

  def import_to_local
    @catalog = Catalog.find(params[:id])
    if @catalog.sync_from_albums.blank?
      Resque.enqueue(LocalSyncCatalog, @catalog.id, @catalog.sync_from_catalog)
    else
      @catalog.sync_from_albums.each do |album_id|
        Resque.enqueue(LocalSyncAlbum, @catalog.id, album_id)
      end
    end
  end

    def set_catalog
      Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:name, :path, :default, :watch_path, :type, :sync_from_catalog, :sync_from_albums)
    end
end
