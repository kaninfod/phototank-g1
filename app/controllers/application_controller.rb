class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 protect_from_forgery with: :exception
 before_filter :set_bucket_in_session

 before_filter :configure_permitted_parameters, if: :devise_controller?
 layout :layout_by_resource

 protected
   def configure_permitted_parameters
       devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
       devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
   end

   def layout_by_resource
     if devise_controller?
       "basic"
     else
       "application"
     end
   end

   def set_bucket_in_session
     if not session.include? 'bucket'
       session[:bucket] = []
     end
   end




end
