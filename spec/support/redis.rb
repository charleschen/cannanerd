RSpec.configure do |config|
  REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
  REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
  
  config.before(:suite) do
    redis_options = {
      "daemonize"     => 'yes',
      "pidfile"       => REDIS_PID,
      "port"          => 6969,
      "timeout"       => 300,
      "save 900"      => 1,
      "save 300"      => 1,
      "save 60"       => 10000,
      "dbfilename"    => "dump.rdb",
      "dir"           => REDIS_CACHE_PATH,
      "loglevel"      => "debug",
      "logfile"       => "stdout",
      "databases"     => 16
    }.map { |k, v| "#{k} #{v}" }.join('\n')
    `echo '#{redis_options}' | redis-server -`
  end    
  config.after(:suite) do
    %x{
      cat #{REDIS_PID} | xargs kill -QUIT
      rm -f #{REDIS_CACHE_PATH}dump.rdb
    }
  end
end

def jobs_pending
  Resque.info[:pending]
end

def jobs_processed
  Resque.info[:processed]
end

def jobs_failed
  Resque.info[:failed]
end

def queues_with_jobs
  Resque.queues.select { |q| Resque.size(q) > 0 }
end

def perform_all_pending_jobs
  while (queues = queues_with_jobs).any?
    queues.each do |queue|
      Resque.reserve(queue).perform
    end
  end
end

def finish_all_jobs(queue_list)
  if Resque.info[:pending]>0
    worker = Resque::Worker.new(*queue_list)
    def worker.done_working
      super
      #puts Resque.info
      shutdown if Resque.info[:pending]<1
    end
    worker.work(0.01)
  end
end

def finish_one_job(queue_list)
  if Resque.info[:pending]>0
    worker = Resque::Worker.new(*queue_list)
    def worker.done_working
      super
      shutdown
    end
    worker.work(0.01)
  end
end

def clear_resque(queue_list)
  queue_list.each {|queue| Resque.remove_queue(queue)}
  Resque::Stat.clear(:processed)
  Resque::Stat.clear(:failed)
  Resque.reset_delayed_queue
end