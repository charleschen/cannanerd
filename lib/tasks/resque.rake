require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

task "resque:scheduler_setup" => :environment do
  # require 'resque'
  # require 'resque_scheduler'
  # require 'resque/scheduler'
  # 
  # # redis server address
  # Resque.redis = $resque_config[rails_env]
  # 
  # # schedule stored in yml
  # #puts rails_root + '/config/resque_schedule.yml'
  # Resque.schedule = YAML.load_file(rails_root + '/config/resque_schedule.yml')
  # 
  # #require 'jobs'
  # #Resque::Scheduler.dynamic = true
end