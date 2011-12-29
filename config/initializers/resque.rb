require 'resque'
require 'resque_scheduler'
require 'resque/job_with_status'
require 'resque/status_server'

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

if Rails.env.production? || Rails.env.staging? 
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  redis = ENV["REDIS_SERVER"]
  #redis = Redis.new()
end

Resque.redis = redis
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

#Likeable.redis = Redis.new()

Likeable.setup do |c|
  if Rails.env.production? || Rails.env.staging? 
    c.redis = redis
  else
    c.redis = Redis.new(:port => ENV["REDIS_SERVER"].split(':').last)
  end
end


Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password = ENV["MASTER_PASSWORD"]
end

# if Rails.env.production? || Rails.env.staging?
#   
#   Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# else
#   Resque.redis = ENV["REDIS_SERVER"]
# end

# Likeable.setup do |c|
#   if Rails.env.production? || Rails.env.staging?
#     c.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#   else
#     c.redis = ENV["REDIS_SERVER"]
#   end
# end

Resque.schedule = YAML.load_file(rails_root + '/config/resque_schedule.yml')

Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds