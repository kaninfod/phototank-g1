
set :stage, :staging
set :rails_env, :staging

server '192.168.2.106', port: 22, roles: [:web, :app,:db, :resque_worker, :resque_scheduler], primary: true
