class WelcomeController < ApplicationController
  def index
    if session.has_key?(:user_id)
      redirect_to Board.where(userid: session[:user_id]).first
    end
  end
end
