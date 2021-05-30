if ENV["RACK_ENV"] == "production"
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV["REDIS_URL"],
      password: ENV["REDIS_PASSWORD"],
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV["REDIS_URL"],
      password: ENV["REDIS_PASSWORD"],
    }
  end
end