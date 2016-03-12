class JobsController < ApplicationController

  def list
    if params.has_key?("query")
      if params[:query] == "failed"
        @jobs = Job.where(status: 2).order(created_at: :desc, id: :desc ).page params[:page]
      end

    else
      @jobs = Job.order(created_at: :desc, id: :desc ).page params[:page]
    end
    render :partial => "jobs/list", locals: {compact: params[:compact]},  :layout => false
  end

  def index
    @jobs = Job.all.order(created_at: :desc, id: :desc ).page params[:page]
  end

end
