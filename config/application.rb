require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'google/api_client'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'net/imap'
require 'net/http'
require 'date'
require 'time'
require 'dropbox-api'
#require 'time_diff'
require 'rest-client'


module Mashboard
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.force_ssl = true
    
    #used to add the asset path for bower based files
    config.assets.paths << Rails.root.join("vendor","assets","bower_components")
    config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")
    config.assets.precompile << %r(.*.(?:eot|svg|ttf|woff)$)
    
    initializer 'setup_asset_pipeline', :group => :all  do |app|
          # We don't want the default of everything that isn't js or css, because it pulls too many things in
          app.config.assets.precompile.shift

          # Explicitly register the extensions we are interested in compiling
          app.config.assets.precompile.push(Proc.new do |path|
            File.extname(path).in? [
              '.html', '.erb', '.haml',                 # Templates
              '.png',  '.gif', '.jpg', '.jpeg',         # Images
              '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
            ]
          end)
    end
    
    
    
  end
end
