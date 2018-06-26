class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # checks if the user is logged in
  helper_method :current_user
  helper_method :sig_fig_time
 
   def current_user
     @current_user ||= Users.find(session[:user_id]) if session[:user_id]
   end
end
