# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Raven.configure do |config|
  config.environments = %w[production]
  config.dsn = Rails.application.credentials.raven_dsn
  config.sanitize_fields = Partynest::Application::FILTER_PARAMS.map(&:to_s)
end
