# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Sidekiq.configure_server do |config|
  Rails.application.credentials.sidekiq_redis_server.try do |redis_config|
    config.redis = redis_config.deep_symbolize_keys if redis_config
  end
end

Sidekiq.configure_client do |config|
  Rails.application.credentials.sidekiq_redis_client.try do |redis_config|
    config.redis = redis_config.deep_symbolize_keys if redis_config
  end
end
