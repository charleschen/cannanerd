require 'resque'
require 'resque_scheduler'
require 'resque/job_with_status'
require 'resque/status_server'

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'


if Rails.env.production? || Rails.env.staging?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = ENV["REDIS_SERVER"]
end

Resque.schedule = YAML.load_file(rails_root + '/config/resque_schedule.yml')

Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds