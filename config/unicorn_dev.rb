# config/unicorn/staging.rb
app_path = "/Users/martinhinge/rails_projects/phototank"

worker_processes   2
preload_app        true
timeout            180
listen             '127.0.0.1:9021'
#user               'pi'
working_directory  app_path
pid                "/Users/martinhinge/rails_projects/phototank/log/unicorn.pid"
stderr_path        "/Users/martinhinge/rails_projects/phototank/log/unicorn.log"
stdout_path        "/Users/martinhinge/rails_projects/phototank/log/unicorn.log"

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