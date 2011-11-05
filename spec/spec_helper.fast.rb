#require 'rubygems'

require 'rspec'

require 'faker'
#require 'factory_girl_rails'
#require 'rspec/rails'

# Load require files from the app
# 
#   app_require 'app/model/profile'

def app_require(file)
  require File.expand_path(file)
end

# Load required support files
# 
# support_require 'database'
# support_require 'database_clear'

def support_require(file)
  require "support/#{file}"
end