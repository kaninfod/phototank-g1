#raspian download:
#https://www.raspberrypi.org/downloads/raspbian/

#raspbian setup:
#https://www.raspberrypi.org/documentation/installation/installing-images/mac.md

#RPI setup:
#https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
#https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma


#dependencies for linux:
# sudo apt-get install exiftool libjpeg-dev libpng-dev graphicsMagick mysql-server mysql-client libmysqlclient-dev nodejs execjs redis-tools imagemagick libmagic-dev

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
gem 'sprockets', '~> 3.7'
gem 'execjs'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.0', '>= 3.0.1'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1'


gem 'will_paginate'

####gem 'bootstrap-sass'

#gem 'bootstrap_form' not uninstalled

#gem 'bootstrap-typeahead-rails'

gem 'font-awesome-sass', '~> 4.5.0'

#gem 'materialize-sass'

gem 'seed_dump'

gem 'clearance'

gem 'geocoder'

gem 'mini_exiftool'
gem 'phashion'
gem "mini_magick"
gem 'ruby-filemagic'

gem 'acts_as_commentable'
gem 'acts_as_votable', '~> 0.10.0'
gem 'acts-as-taggable-on', '~> 4.0'


gem 'jquery-turbolinks'
#gem 'squeel'
gem 'puma'
gem 'silencer', '~> 0.6.0'

gem 'rack-protection', github: 'sinatra/rack-protection'
gem 'sinatra', github: 'sinatra/sinatra'
gem 'resque'
gem 'resque-loner'
gem 'resque-scheduler'
gem 'active_scheduler'

gem "rails-settings-cached"

gem "haml-rails", "~> 0.9"


gem 'flickraw', '~> 0.9.8'
gem 'dropbox-sdk'
#gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'meta_request'

group :test do
  gem 'faker'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'resque_spec'
  gem 'database_cleaner'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'capistrano',         require: false
  #gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-rails-collection'
  gem "capistrano-resque", "~> 0.2.2", require: false
  gem 'foreman'
  gem 'awesome_print', :require => 'ap'
  gem 'pry-rails'
  gem 'pry-byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

end


group :production do
  gem 'mysql2'
end
