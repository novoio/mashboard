# Google's OAuth2 docs. Make sure you are familiar with all the options
# before attempting to configure this gem.
# https://developers.google.com/accounts/docs/OAuth2Login

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :google_oauth2, Mashboard::Application.config.google_id, Mashboard::Application.config.google_secret, {
    :scope => 'userinfo.email,userinfo.profile,calendar,drive,tasks,https://mail.google.com/,https://www.google.com/m8/feeds',
    :approval_prompt => "force",
    :access_type => 'offline'
    
  }

end