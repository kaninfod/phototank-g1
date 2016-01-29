class LocationsController < ApplicationController
  def index
    @locations = Location.order(:country).page params[:page]
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def view

    @photos = Photo.where(:location => params[:id]).page params[:page]
    @location = Location.find(params[:id])
    @bucket = session[:bucket]
  end
  
end
