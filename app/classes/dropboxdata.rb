class Dropboxdata
  attr_accessor :oauth_token, :oauth_secret
  
  def initialize(token, secret)
    self.oauth_token = token
    self.oauth_secret = secret
  end
  
  def pull
    client = Dropbox::API::Client.new(:token  => self.oauth_token, :secret => self.oauth_secret)
    return client.ls
  end

  def search(searchText)
    client = Dropbox::API::Client.new(:token  => self.oauth_token, :secret => self.oauth_secret)
    results = client.search "#{searchText}"
    return results
  end

  def download(path)
    client = Dropbox::API::Client.new(:token  => self.oauth_token, :secret => self.oauth_secret)
    results = client.search(path)
    url = results[0].direct_url.url
    return url
  end
end