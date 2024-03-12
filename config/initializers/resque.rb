require "resque/server"

if Rails.env.development?
  Resque.redis = Redis.new(host: "localhost", port: '6379')
elsif Rails.env.production?
  uri = URI.parse(ENV["RADIS_URL"])
  REDIS =  Redis.new(host: "localhost", port:uri.port)
  Resque.redis = REDIS
end
