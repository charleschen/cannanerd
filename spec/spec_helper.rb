require 'rubygems'
require 'spork'

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'faker'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    
    config.include(MailerMacros)
    config.before(:each) { reset_email }
    
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
    
    def test_sign_in(user)
      sign_in(user)
    end

    def test_sign_out(user)
      sign_out(user)
    end

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
    
    
    # when using selenium, need to use DatabaseCleaner gem
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # Redis sever setup, commented out for now
    
    # REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
    # REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
    # 
    # config.before(:suite) do
    #   redis_options = {
    #     "daemonize"     => 'yes',
    #     "pidfile"       => REDIS_PID,
    #     "port"          => 6969,
    #     "timeout"       => 300,
    #     "save 900"      => 1,
    #     "save 300"      => 1,
    #     "save 60"       => 10000,
    #     "dbfilename"    => "dump.rdb",
    #     "dir"           => REDIS_CACHE_PATH,
    #     "loglevel"      => "debug",
    #     "logfile"       => "stdout",
    #     "databases"     => 16
    #   }.map { |k, v| "#{k} #{v}" }.join('\n')
    #   `echo '#{redis_options}' | redis-server -`
    # end    
    # config.after(:suite) do
    #   %x{
    #     cat #{REDIS_PID} | xargs kill -QUIT
    #     rm -f #{REDIS_CACHE_PATH}dump.rdb
    #   }
    # end
    
  end
end

Spork.each_run do
  
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.