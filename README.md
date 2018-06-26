Steps for running mashboard as localhost:

Optional: Install Homebrew (OS X only): http://brew.sh/

1. Install Ruby: https://www.ruby-lang.org/en/installation/

2. Install RubyGems: http://rubygems.org/pages/download

3. Install Postgres: http://www.postgresql.org/download/

Homebrew install: http://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/

Easy OS X install: http://postgresapp.com/

Install Rails: From the command line enter gem install rails

Download the repository

Install git if needed: http://git-scm.com/book/en/Getting-Started-Installing-Git

Checkout a local copy using the command (will checkout in current active folder) git clone <username>@bitbucket.org/<username>/mashboard.git

You can find more details in our useing git documentation or reference the bitbucket website for help with command and creating branches

From the command line navigate to top level folder of the app and enter bundle install to install required gems

From the command line run rake db:migrate to setup the database

From the command line run bundle exec unicorn -p 3000 -c config/unicorn.rb

If everything went correctly, you’ll have the Mashboard source code running, you can navigate to localhost:3000 to verify