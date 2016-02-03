class LocationsController < ApplicationController
  def index
    @locations = Location.where{(latitude.not_eq(0) & longitude.not_eq(0))}.order(:country).page params[:page]
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def view

    @photos = Photo.where(:location => params[:id]).page params[:page]
    @location = Location.find(params[:id])
    @bucket = session[:bucket]
  end
  
  def lookup
    Location.geolocate
    redirect_to :action => 'index'
  end 
  
end
