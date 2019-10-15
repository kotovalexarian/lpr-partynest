# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Raven.configure do |config|
  config.async = RavenJob.method :perform_later
  config.current_environment = Rails.env
  config.dsn = Rails.application.credentials.raven_dsn
  config.environments = %w[production staging]
  config.excluded_exceptions = %w[
    AbstractController::ActionNotFound
    ActionController::InvalidAuthenticityToken
    ActionController::RoutingError
    ActionController::UnknownAction
    ActiveRecord::RecordNotFound
    CGI::Session::CookieStore::TamperedWithCookie
    Mongoid::Errors::DocumentNotFound
    Sinatra::NotFound
    ActiveJob::DeserializationError
  ]
  config.sample_rate = 1.0
  config.sanitize_fields = Partynest::Application::FILTER_PARAMS.map(&:to_s)
  config.silence_ready = false
  config.ssl_verification = true
end
