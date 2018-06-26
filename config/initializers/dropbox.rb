#set the dropbox app key and secret, from dropbox dev site
Dropbox::API::Config.app_key = 'y7hs301litbw7t2' 
Dropbox::API::Config.app_secret = 'cme2kw0e6tksipv'

#using dropbox instead of sandbox to get access to all files
Dropbox::API::Config.mode = 'dropbox'