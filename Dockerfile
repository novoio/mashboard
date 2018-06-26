
FROM ruby:2.1

# Install required libraries and dependencies
RUN apt-get update && apt-get install -qy nodejs postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Set Rails version
ENV RAILS_VERSION 4.1.0

# Install Rails
RUN gem install rails --version "$RAILS_VERSION"

# Create directory from where the code will run 
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app

# Make webserver reachable to the outside world
EXPOSE 3000

# Set ENV variables
ENV PORT=3000

# Start the web app
CMD ["foreman","start"]

# Install the necessary gems 
ADD Gemfile /usr/src/app/Gemfile  
ADD Gemfile.lock /usr/src/app/Gemfile.lock  
RUN bundle install --without development test

# Add rails project (from same dir as Dockerfile) to project directory
ADD ./ /usr/src/app

#Run rake tasks
RUN RAILS_ENV=production 

#rake db:create db:migrate