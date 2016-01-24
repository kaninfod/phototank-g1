class LocationsController < ApplicationController
  def index
    @locations = Location.order(:country).page params[:page]
  end
  
  def show
    @location = Location.find(params[:id])
  end
end
