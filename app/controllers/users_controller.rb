class UsersController < ApplicationController
  def new
    if current_user
      redirect_to current_user
    end
  end
  
  def create
    @user = Users.new(params[:user])
  end
  
  def show
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    if params[:id].to_i == session[:user_id]
      @user = Users.find(params[:id])
    else
      render :status => :forbidden, :text => "Forbidden fruit:/n session id:#{session[:user_id]} "
    end
  end
  
  def index
    @zone = ActiveSupport::TimeZone.new("Central Time (US & Canada)")
    if current_user.email == "nruegger@gmail.com"
      @users =Users.all
    else
      render :status => :forbidden, :text => "Forbidden fruit"
    end
  end
end
