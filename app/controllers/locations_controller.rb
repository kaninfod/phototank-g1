class LocationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @locations = Location.where{(latitude.not_eq(0) & longitude.not_eq(0))}.order(:country).page params[:page]
  end

  def show
    @location = Location.find(params[:id])
  end

  def view
    if params.has_key?(:viewmode)
      @view = params[:viewmode]
    else
      @view = 'grid'
    end
    @bucket = session[:bucket]
    @photos = Photo.where(:location => params[:id]).page params[:page]
    @location = Location.find(params[:id])
    @bucket = session[:bucket]
  end

  def lookup
    Location.geolocate
    redirect_to :action => 'index'
  end

  def typeahead

    addresses = []
    search  = Location.typeahead_search(params[:query])
    render json: search
  end

end
