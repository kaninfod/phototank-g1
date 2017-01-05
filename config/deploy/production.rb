set :stage, :production
set :rails_env, :production

server '192.168.2.102', port: 22, roles: [:web, :app], primary: true
server '192.168.2.103', port: 22, roles: [:db, :resque_worker, :resque_scheduler]
