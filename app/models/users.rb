class Users < ActiveRecord::Base
  #serialize :provider, Array
  #serialize :uid, Hash
  #serialize :oauth_token, Hash
  #serialize :oauth_secret, Hash #used by some service like dropbox
  #serialize :oauth_expires_at, Hash
  #store :oauth_token, :oauth_expires_at, :uid #use the provider name as they key for access
  has_many :boards, dependent: :destroy
  has_many :widgets, through: :boards
  # assigns information pulled from omniauth gem
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      unless auth.credentials.refresh_token == "" ||  auth.credentials.refresh_token.nil?
        user.refresh_token = auth.credentials.refresh_token
      end
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
      Source.from_omniauth(auth, user)
    end
  end
    
  def list_boards
    return Board.where(userid: self.id)
  end
  
  def list_widgets
    return Widgets.where(userid: self.id)
  end
  
  def list_sources
    return Source.where(userid: self.id)
  end
  
  def remove_widget(widget)
    self.list_boards.each do |board|
      if board.widgets.include?(widget.id)
        board.widgets.delete(widget.id)
      end
      board.save!
    end
    widget.destroy
    return true
  end
    
end
