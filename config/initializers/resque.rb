require 'resque/server'
#require 'resque_scheduler'
config = YAML.load(File.open("#{Rails.root}/config/resque.yml"))[Rails.env]
Resque.redis = Redis.new(host: config['host'], port: config['port'], db: config['db'])

Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_scheduler.yml")
# logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'a')
# logfile.sync = true
# Resque.logger = ActiveSupport::Logger.new(logfile)
# Resque.logger.level = Logger::DEBUG
# Resque.logger.info "logger initialized"
