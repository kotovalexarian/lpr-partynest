# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

server_conf = Rails.application.config_for(:sidekiq_server).deep_symbolize_keys
client_conf = Rails.application.config_for(:sidekiq_client).deep_symbolize_keys

Sidekiq.configure_server do |config|
  config.redis = {
    host:     server_conf[:redis_host],
    port:     server_conf[:redis_port],
    db:       server_conf[:redis_db],
    password: server_conf[:redis_password],
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host:     client_conf[:redis_host],
    port:     client_conf[:redis_port],
    db:       client_conf[:redis_db],
    password: client_conf[:redis_password],
  }
end
