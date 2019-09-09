# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

client_conf = Rails.application.settings :sidekiq_client
server_conf = Rails.application.settings :sidekiq_server

Sidekiq.configure_client do |config|
  config.redis = {
    host: client_conf[:host],
    port: client_conf[:port],
    db: client_conf[:db],
    password: client_conf[:password],
    ssl: client_conf[:ssl],
    ssl_params: client_conf[:ssl_params],
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    host: server_conf[:host],
    port: server_conf[:port],
    db: server_conf[:db],
    password: server_conf[:password],
    ssl: client_conf[:ssl],
    ssl_params: client_conf[:ssl_params],
  }
end
