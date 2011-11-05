# require 'database_cleaner'
# 
# RSpec.configure do |config|
#   #config.use_transactional_fixtures = false
#   config.before(:suite) { DatabaseCleaner.strategy = :truncation }
#   config.before(:each) { DatabaseCleaner.start }
#   config.after(:each) { DatabaseCleaner.clean }
# end