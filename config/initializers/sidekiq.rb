# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

client_conf = Rails.application.settings :sidekiq_client
server_conf = Rails.application.settings :sidekiq_server

Sidekiq.configure_client do |config|
  config.redis = {
    host: client_conf[:redis_host],
    port: client_conf[:redis_port],
    db: client_conf[:redis_db],
    password: client_conf[:redis_password],
    ssl_params: client_conf[:redis_ssl],
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    host: server_conf[:redis_host],
    port: server_conf[:redis_port],
    db: server_conf[:redis_db],
    password: server_conf[:redis_password],
    ssl_params: client_conf[:redis_ssl],
  }
end
