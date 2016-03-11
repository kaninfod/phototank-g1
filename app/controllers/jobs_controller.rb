class JobsController < ApplicationController

  def index
    @jobs = Job.all.order(created_at: :desc, id: :desc ).page params[:page]
  end

end
