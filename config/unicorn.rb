app_root = "/slowmonster"

worker_processes 2
working_directory "#{app_root}"
preload_app true
timeout 30
#listen "#{app_root}/tmp/sockets/unicorn.sock", :backlog => 2048
listen 8080

pid "#{app_root}/tmp/pids/unicorn.pid"
stderr_path "#{app_root}/log/unicorn.log"
stdout_path "#{app_root}/log/unicorn.log"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
