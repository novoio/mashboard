class Widgets < ActiveRecord::Base
  serialize :sources, Array
  belongs_to :user
  belongs_to :board
  has_many :filters, dependent: :destroy
  
  attr_accessor :data_cache
  
  #module includes
  include Sigfigtime, Combiner
  
  def list_items()
    self.data_cache = Datacache.new(self.userid.to_s + self.id.to_s)

## TEST TO BYPASS Cache  Remove when debug Evernote completed.
      # self.sources.each do |source_id|
      #   @source = Source.find(source_id)
      #     puts "*******************%%%%%%% Provider #{@source.provider}"
      #   case @source.provider

      #   when "evernote"
      #     puts "*******************%%%%%%%  Evernote pull"
      #     @items = Evernotedata.new(@source.oauth_token, @source.oauth_secret).pull
      #   else
      #   end
      # end

    if self.data_cache.cached?
      @items = self.data_cache.data[:items]
      self.sources.each do |source_id|
        @source = Source.find(source_id)
        case @source.provider
        when "google"
          if self.data_cache.data.has_key?(:google_data)
            gdata = self.data_cache.data[:google_data]
            if self.widget_type == "files"
              @result = Array.new
            end
            @source.refresh_token_if_expired
            @result = gdata.pull(@source.oauth_token)
            if self.widget_type == "files"
              @items = combine_files(@items, @result, @source)
            else
              if @items.is_a?(Array)
               @items = @items + @result
              else
               @items = @result
              end
            end
          end
        when "dropbox"
          # if needed

        when "evernote"
          # if needed
        else
        end
      end
    else
      puts "%%%% NO CACHE"
      gdata = nil
      self.sources.each do |source_id|
        @source = Source.find(source_id)
        case @source.provider
        when "google"
          # if self.widget_type == "files"
            @result = Array.new
          # end
          @source.refresh_token_if_expired
          gdata = Googledata.new(self.widget_type)
          @result = gdata.pull(@source.oauth_token)
          if self.widget_type == "files"
            @items = combine_files(@items, @result, @source)
          else
            if @items.is_a?(Array)
             @items = @items + @result
            else
             @items = @result
            end
          end
        when "dropbox"
          @result = Dropboxdata.new(@source.oauth_token, @source.oauth_secret).pull
          @items = combine_files(@items, @result, @source)

        when "evernote"
          puts "*******************%%%%%%%  Evernote pull"
          @items = Evernotedata.new(@source.oauth_token, @source.oauth_secret).pull
        else
        end
      end
      #need to add api page information to cache
      cache_data = {:google_data => gdata, :items => @items}
      self.data_cache.cache_data!(cache_data)
    end
    return @items
  end

  def search(params)
    # Issue search with search text
    # push into cache
    self.data_cache = Datacache.new(self.userid.to_s + self.id.to_s)
    if self.data_cache.cached?
      @items = self.data_cache.data
    end
    puts "Widget Search #{self.widget_type} for #{params}"
    self.sources.each do |source_id|
      @source = Source.find(source_id)
      case @source.provider
      when "google"
        puts "GOOGLE ********"
        case self.widget_type
        when "files"
          puts "*** Search files"
          @result = Googledata.new(self.widget_type).files_search(@source.oauth_token, params[:searchText])
          @items = combine_files(@items, @result, @source)
          self.data_cache.cache_data!(@items)
        when "email"
          puts "*** email files"
          @result = Googledata.new(self.widget_type).email_search(@source.oauth_token, params[:searchText])
          if @items.is_a?(Array)
           @items = @items + @result
          else
           @items = @result
          end
          self.data_cache.cache_data!(@items)
        when "calendar"
          puts "*** calendar files"
          @result = Googledata.new(self.widget_type).calendar_search(@source.oauth_token, params[:searchText])
          if @items.is_a?(Array)
           @items = @items + @result
          else
           @items = @result
          end
          self.data_cache.cache_data!(@items)
        when"contact"
          puts "*** Contact files"
        end
      when "dropbox"
        puts "Dropbox search"
        @items = combine_files(@items, Dropboxdata.new(@source.oauth_token, @source.oauth_secret).search(params[:searchText]), @source)
        self.data_cache.cache_data!(@items)
      when "notes"
        puts "Evernote search"
      else
        puts "Search Not supported"
      end
      puts "Search source: #{@source.provider}"
    end
  end

  def dropbox_download(params)
    @source = Source.find(params[:id])
    Dropboxdata.new(@source.oauth_token, @source.oauth_secret).download(params[:path])
  end

  def applied_filters
    self.filters.where(is_applied: true)
  end
end

