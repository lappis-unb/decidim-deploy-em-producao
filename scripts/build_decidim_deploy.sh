#!/bin/sh

# Navigate to the application directory
cd /srv/decide || exit 1

source ~/.bashrc

# Create necessary directories
mkdir -p tmp/sockets tmp/pids log

# Set up bundler configuration
bundle config set without 'test development'
bundle config set --local path 'vendor/bundle'

# Install dependencies
bundle install

# Update specific gem conservatively
bundle update decidim-homes --conservative

# Install JavaScript dependencies
yarn install

# Precompile assets
RAILS_ENV=production bundle exec rake assets:precompile

# Set up the database
RAILS_ENV=production bundle exec rake db:create
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake db:seed
