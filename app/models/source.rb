class Source < ActiveRecord::Base
  
  
  #authenticate google as a source only
  def self.from_omniauth(auth, current_user)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |source|
      #add check to see if the source already exists, only update token and secret if so
      case auth.provider
      when "google_oauth2"
        provider = "google"
      else
        provider = "google"
      end
      @source = Source.where("user_id = ? AND email = ? AND provider = ?", current_user.id, auth.info.email, provider).first
      if @source.blank?
        source = Source.new
        source.provider = provider
        source.uid = auth.uid
        source.user_id = current_user.id
        source.name = auth.info.name
        source.email = auth.info.email
        unless auth.credentials.refresh_token == "" ||  auth.credentials.refresh_token.nil?
          source.refresh_token = auth.credentials.refresh_token
        end
        source.oauth_token = auth.credentials.token
        source.oauth_expires_at = Time.at(auth.credentials.expires_at)
        source.save!
      else
        @source.oauth_token = auth.credentials.token
        @source.oauth_expires_at = Time.at(auth.credentials.expires_at)
        @source.save!
        source = @source
      end
    end
  end
  
  def provider_name
    "#{self.provider} - #{self.email}"
  end

  def refresh_token_if_expired
    refresh_oauth_token if self.token_expired?
  end
  
  def token_expired?
    expiry = Time.parse(self.oauth_expires_at.to_s) 
    return true if expiry < Time.now # expired token
    token_expires_at = expiry
    save if changed?
    false # token not expired
  end
  
  def refresh_oauth_token
    source_user = Users.find(self.user_id)
    client = Google::APIClient.new
    client.authorization.client_id = Mashboard::Application.config.google_id
    client.authorization.client_secret = Mashboard::Application.config.google_secret
    client.authorization.grant_type = 'refresh_token'
    client.authorization.refresh_token = self.refresh_token
    client.authorization.fetch_access_token!
    self.oauth_token = client.authorization.access_token 
    self.oauth_expires_at = DateTime.now + client.authorization.expires_in.to_i.seconds
    self.save
    if source_user.provider == "google_oauth2"
      provider = "google"
    end
    if self.email == source_user.email && self.provider == provider
      source_user.oauth_token = client.authorization.access_token
      source_user.oauth_expires_at = DateTime.now + client.authorization.expires_in.to_i.seconds
      source_user.save
    end
  end
  
end
