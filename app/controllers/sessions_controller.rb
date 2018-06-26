class SessionsController < ApplicationController
  def create
    #calls for authentication using omniauth
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    if @current_user.blank?
      user = Users.from_omniauth(env["omniauth.auth"])
      #creates session with authentication info
      session[:user_id] = user.id
      if Board.where(userid: user.id).blank?
        board = Board.new
        board.auto_setup(user)
        board.save!
        redirect_to board
      else
        redirect_to Board.where(userid: user.id).first
      end
    else
      #add as source
      source = Source.from_omniauth(env["omniauth.auth"], @current_user)
      redirect_to Board.where(userid: @current_user.id).first
    end
    
  end

  def destroy
    #clears the session information
    session[:user_id] = nil
    #returns user to root
    redirect_to root_path
  end
end
