# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Raven.configure do |config|
  config.dsn = Rails.application.secrets.raven_dsn
end
