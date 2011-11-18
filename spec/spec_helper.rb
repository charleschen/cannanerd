ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'
require 'faker'
require 'database_cleaner'
require 'factory_girl_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
#Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  # config.include(MailerMacros)
  # config.before(:each) do 
  #   reset_email
  # end
  config.mock_with :rspec
  config.include Factory::Syntax::Methods
  
  
  
  def app_require(file)
    require File.expand_path(file)
  end

  def support_require(file)
    require "support/#{file}"
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  #config.use_transactional_fixtures = true
  # config.infer_base_class_for_anonymous_controllers = false
  # 
  # config.treat_symbols_as_metadata_keys_with_true_values = true
  # config.filter_run :focus => true
  # config.run_all_when_everything_filtered = true
  
  
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
  
  def create_questionaire_data
    questionnaire = Questionnaire.first
    multichoice = true
    
    3.times do
      question = Factory(:question, :questionnaire_id => questionnaire.id, :multichoice => multichoice)
      multichoice = !multichoice
      3.times do
        answer = Factory(:answer)
        question.questionships.create(:answer_id => answer.id)
      end
    end
  end
end


#require 'rubygems'
#require 'spork'

# Spork.prefork do
# 
#   # This file is copied to spec/ when you run 'rails generate rspec:install'
#   ENV["RAILS_ENV"] ||= 'test'
#   require File.expand_path("../../config/environment", __FILE__)
#   require 'rspec/rails'
#   #require 'rspec/autorun'
#   require 'faker'
# 
#   # Requires supporting ruby files with custom matchers and macros, etc,
#   # in spec/support/ and its subdirectories.
#   Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
# 
#   RSpec.configure do |config|
#     
#     config.include(MailerMacros)
#     config.before(:each) do 
#       reset_email
#     end
#     
#     config.mock_with :rspec
#     
#     def test_sign_in(user)
#       sign_in(user)
#     end
# 
#     def test_sign_out(user)
#       sign_out(user)
#     end
# 
#     config.fixture_path = "#{::Rails.root}/spec/fixtures"
#     #config.use_transactional_fixtures = true
#     # config.infer_base_class_for_anonymous_controllers = false
#     # 
#     # config.treat_symbols_as_metadata_keys_with_true_values = true
#     # config.filter_run :focus => true
#     # config.run_all_when_everything_filtered = true
#     
#     
#     # when using selenium, need to use DatabaseCleaner gem
#      config.use_transactional_fixtures = false
# 
#     config.before(:suite) do
#       DatabaseCleaner.strategy = :truncation
#     end
# 
#     config.before(:each) do
#       DatabaseCleaner.start
#     end
# 
#     config.after(:each) do
#       DatabaseCleaner.clean
#     end
# 
#     # Redis sever setup, commented out for now
#     
#     # REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
#     # REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
#     # 
#     # config.before(:suite) do
#     #   redis_options = {
#     #     "daemonize"     => 'yes',
#     #     "pidfile"       => REDIS_PID,
#     #     "port"          => 6969,
#     #     "timeout"       => 300,
#     #     "save 900"      => 1,
#     #     "save 300"      => 1,
#     #     "save 60"       => 10000,
#     #     "dbfilename"    => "dump.rdb",
#     #     "dir"           => REDIS_CACHE_PATH,
#     #     "loglevel"      => "debug",
#     #     "logfile"       => "stdout",
#     #     "databases"     => 16
#     #   }.map { |k, v| "#{k} #{v}" }.join('\n')
#     #   `echo '#{redis_options}' | redis-server -`
#     # end    
#     # config.after(:suite) do
#     #   %x{
#     #     cat #{REDIS_PID} | xargs kill -QUIT
#     #     rm -f #{REDIS_CACHE_PATH}dump.rdb
#     #   }
#     # end
#     
#   end
# end
# 
# Spork.each_run do
#   #FactoryGirl.reload 
#   #$rspec_start_time = Time.now
#   ActiveSupport::Dependencies.clear
#   ActiveRecord::Base.instantiate_observers
# end if Spork.using_spork?