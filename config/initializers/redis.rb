#$redis = Redis.new(:host => ENV["REDIS_HOST"], :port => ENV["REDIS_PORT"])
$redis = Redis.new(:host => "192.168.2.103", :port => 6379)
