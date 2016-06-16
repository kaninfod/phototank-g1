class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_bucket_in_session

  before_filter :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :json_request?
  layout :layout_by_resource

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user|
         user.permit(:name, :email, :password)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user|
         user.permit(:name, :email, :password, :current_password, :avatar, :image_id)
      end

      # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
      # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :avatar)}
   end

   def layout_by_resource
     if devise_controller?
       if not ["edit"].include? params[:action]
         "basic"
       end
     else
       "application"
     end
   end

   def set_bucket_in_session
     if not session.include? 'bucket'
       session[:bucket] = []
     end
   end

   def json_request?
     request.format.json?
   end


end
