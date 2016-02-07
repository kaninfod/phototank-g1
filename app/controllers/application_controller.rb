class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 protect_from_forgery with: :exception
 before_filter :set_bucket_in_session
 
 def set_bucket_in_session
   if not session.include? 'bucket'
     session[:bucket] = []
   end
   @GR = GITREVISION
   
 end
 
 
 
 
end
