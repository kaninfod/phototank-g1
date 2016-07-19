class LocationsController < ApplicationController
  before_action :require_login
  def index
    order = :country
    order = params[:order] unless not params.has_key?(:order)
    query = "%#{params[:q]}%"
    query ||="%"
    @locations = Location.where{address.matches(query)}.where{(latitude.not_eq(0) & longitude.not_eq(0))}.order(order).page params[:page]
  end

  def show
    @location = Location.find(params[:id])
  end

  def view

    @view = 'grid'

    @bucket = session[:bucket]
    @photos = Photo.where(:location => params[:id]).page params[:page]
    @location = Location.find(params[:id])
    @bucket = session[:bucket]
    #If this was requested from an ajax call it should be rendered with slim view
    if request.xhr?
      render :partial=>"photos/grid"
    end
  end

  def lookup
    Location.geolocate
    redirect_to :action => 'index'
  end

  def typeahead
    search  = Location.typeahead_search(params[:term])
    render json: search
  end

  def new_from_coordinate_string
    new_location = Location.new
    new_location.longitude = params[:longitude]
    new_location.latitude = params[:latitude]
    new_location.get_location
    render json: new_location
  end

  def new
    @return_url = request.referer
  end

  def create
    new_location = Location.new(params.permit(:latitude, :longitude, :country, :city, :address, :state, :postcode, :road, :suburb))
    if new_location == nil or new_location.latitude == nil
      render status: 406
    elsif new_location.nearbys(1).count(:all) > 0
      render status: 409
    else
      new_location.save
      render json: new_location if request.xhr?
    end
  end

end
