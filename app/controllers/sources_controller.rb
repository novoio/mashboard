class SourcesController < ApplicationController
  def new
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    
  end
  
  def create
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
  end
  
  def index
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @sources = Source.where(:user_id => @current_user.id)
    
  end
  
  def show
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @source = Source.find(params[:id])
    if @source.provider == "dropbox"
      @client = Dropbox::API::Client.new(:token  => @source.oauth_token, :secret => @source.oauth_secret)
    end
  end

end
