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
    if params[:catalog][:type] == "DropboxCatalog"
      redirect_to "/catalogs/authorize?name=#{params[:catalog][:name]}"
    else
      @catalog = Catalog.new(catalog_params)
      if @catalog.save
        redirect_to action: 'manage', id:@catalog
      end
    end
  end

  def destroy
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
      when 'MasterCatalog'
        catalog = Catalog.master
        catalog.import
      when 'LocalCatalog'
        catalog = Catalog.find(params[:id])
        catalog.import
      when 'DropboxCatalog'
        catalog = Catalog.find(params[:id])
        catalog.import

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
        when "DropboxCatalog"
          catalog['sync_from_catalog'] = params[:sync_from_catalog_id]
          catalog['sync_from_albums'] = nil
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


  def authorize()
    dropbox_data = {
      :appkey => "knb2b9w893ilrlj",
      :appsecret => "bqsdycbxph2bqdm",
      :redirect_uri => "http://localhost:3000/catalogs/authorize_callback",
      :access_token => "",
      :user_id => ""}
    catalog = Catalog.new(type: "DropboxCatalog", name: params[:name], ext_store_data: dropbox_data)
    catalog.save
    flow = DropboxOAuth2Flow.new(catalog.appkey, catalog.appsecret, catalog.redirect_uri, session, :dropbox_auth_csrf_token)
    authorize_url = flow.start()
    redirect_to authorize_url
  end

  def authorize_callback
    catalog = Catalog.where(type: "DropboxCatalog").last
    flow = DropboxOAuth2Flow.new(catalog.appkey, catalog.appsecret, catalog.redirect_uri, session, :dropbox_auth_csrf_token)
    catalog.access_token, catalog.user_id, url_state = flow.finish(params)
    catalog.save
    redirect_to "/catalogs"
  end

  private

  def set_catalog
    Catalog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def catalog_params
    params.require(:catalog).permit(:name, :path, :default, :watch_path, :type, :sync_from_catalog, :sync_from_albums)
  end
end
