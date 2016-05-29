#require 'resque/failure/multiple'
#require 'resque/failure/redis'
#Resque::Failure::Multiple.classes = [Resque::Failure::Redis]
#Resque::Failure.backend = Resque::Failure::Multiple
#Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each { |file| require file }
config = YAML.load(File.open("#{Rails.root}/config/resque.yml"))[Rails.env]
Resque.redis = Redis.new(host: config['host'], port: config['port'], db: config['db'])



#rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
#rails_env = ENV['RAILS_ENV'] || 'development'

#resque_config = YAML.load_file(rails_root + '/config/resque.yml')
#Resque.redis = resque_config[rails_env]
Rails.logger.warn Resque.redis



Resque.logger = MonoLogger.new(File.open("#{Rails.root}/log/resque.log", "w+"))
Resque.logger.formatter = Resque::QuietFormatter.new
