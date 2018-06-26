class Datacache
  
  attr_accessor :id, :data, :updated
  
  def initialize(id)
    self.id = id #should be user id + widget id
    if self.cached?
      self.data = Rails.cache.read(self.id)
    end
  end
  
  def cached?
    #check if cache is available
    return Rails.cache.exist?(self.id)
  end

  def cache_data!(data)
    #cache the supplied data
    self.data = data
    Rails.cache.write(self.id, self.data, :expires_in => 5.minutes)
    self.updated = Time.now
  end
  
  def clear_cache!
    Rails.cache.delete(self.id)
  end
end