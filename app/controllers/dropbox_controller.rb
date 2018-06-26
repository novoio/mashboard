class DropboxController < ApplicationController
  def authorize
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:dropbox_token] = request_token.token
    session[:dropbox_token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => "https://#{request.host_with_port}/auth/dropbox_oauth2/callback")
  end

  def callback
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, session[:dropbox_token], session[:dropbox_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    
    @client = Dropbox::API::Client.new(:token  => access_token.token, :secret => access_token.secret)
    @source = Source.where("user_id = ? AND provider = ?", @current_user.id, "dropbox").first
    if @source.blank?
      source = Source.new
      source.provider = "dropbox"
      source.uid = @client.account.uid
      source.name = @client.account.display_name
      source.email = @client.account.email
      source.user_id = @current_user.id
      source.oauth_token = access_token.token
      source.oauth_secret = access_token.secret
      source.save!
      redirect_to source
    else
      @source.oauth_token = access_token.token
      @source.oauth_secret = access_token.secret
      @source.save!
      redirect_to @source
    end
    
  end

end
