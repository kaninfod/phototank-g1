# config/unicorn/staging.rb
app_path = "/home/pi/rails/phototank/current"

worker_processes   2
preload_app        true
timeout            180
listen             '127.0.0.1:9021'
user               'apps', 'apps'
working_directory  app_path
pid                "/home/pi/rails/phototank/shared/unicorn.pid"
stderr_path        "/home/pi/rails/phototank/shared/unicorn.log"
stdout_path        "/home/pi/rails/phototank/shared/unicorn.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end