source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rake', '0.9.2.2'
gem 'will_paginate', '3.0.2'
gem 'authlogic'
gem 'resque', :require => "resque/server"
gem 'resque-scheduler', :require => 'resque_scheduler', git: 'git://github.com/bvandenbos/resque-scheduler'
gem 'resque-status'
gem 'exceptional'
gem 'declarative_authorization'
gem 'faker', '0.3.1'
gem 'geocoder'
gem 'ruby_parser'
gem 'heroku'

group :asset do
	gem 'sass-rails', "~> 3.1.0"
	gem 'coffee-rails', "~> 3.1.0"
	gem 'uglifier'
end

gem 'jquery-rails'

group :development do
  gem 'rspec-rails', '2.7.0'
	gem 'rspec-core', '2.7.1'
  gem 'annotate', '2.4.0'
  gem 'nifty-generators'
  gem 'sqlite3'
  gem 'fakeweb'
	gem 'hirb'
end

group :test do
  gem 'rspec-rails', '2.7.0'
	gem 'rspec-core', '2.7.1'
  #gem 'webrat', '0.7.1'
  gem 'factory_girl_rails', '1.3.0'
  gem 'sqlite3'
  gem 'fakeweb'
	gem 'timecop'
	gem 'capybara'
	gem 'database_cleaner'
	gem 'spork'
	gem 'rb-fsevent'
	gem 'guard-livereload'
	gem 'growl_notify'
end

group :production do
  gem 'thin'
  gem 'pg'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debcusug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
gem "mocha", :group => :test
