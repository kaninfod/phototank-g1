class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_bucket_in_session
  before_filter :set_layout



  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  def set_layout
    simple = ["clearance/sessions", "clearance/passwords", "clearance/users"]
    if simple.include? params['controller']
      self.class.layout "basic"
    end
  end




  protected
   def set_bucket_in_session
     if not session.include? 'bucket'
       session[:bucket] = []
     end
   end

   def json_request?
     request.format.json?
   end


end
