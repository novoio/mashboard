class EvernoteController < ApplicationController
  def authorize
    consumer = OAuth::Consumer.new('tony3077-5264', '35d1578bfcaee8e1', {
      :site               => "https://sandbox.evernote.com/",
      :request_token_path => "/oauth",
      :access_token_path  => "/oauth",
      :authorize_path     => "/OAuth.action"
      })

    request_token = consumer.get_request_token(:oauth_callback => "http://#{request.host_with_port}/auth/evernote_oauth2/callback")
    redirect_url = request_token.authorize_url(:oauth_callback => "http://#{request.host_with_port}/auth/evernote_oauth2/callback")
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to redirect_url
  end

  def callback
    consumer = OAuth::Consumer.new('tony3077-5264', '35d1578bfcaee8e1', {
      :site               => "https://sandbox.evernote.com/",
      :request_token_path => "/oauth",
      :access_token_path  => "/oauth",
      :authorize_path     => "/OAuth.action"
      })

    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])

    puts "request_token: #{request_token}"

    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    token = access_token.token

    @current_user ||= Users.find(session[:user_id]) if session[:user_id]

    @source = Source.where("user_id = ? AND provider = ?", @current_user.id, "evernote").first
    if @source.blank?
      source = Source.new
    	source.provider = "evernote"
	    source.uid = access_token.params[:edam_userId]
	    source.user_id = @current_user.id
	    # Change later to be username of authenticated evernote user.
      source.name = 'tony3077-5264'
	    source.oauth_token = token
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