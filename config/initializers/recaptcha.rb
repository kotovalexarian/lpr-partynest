# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.settings(:recaptcha).presence.try do |settings|
  Recaptcha.configure do |config|
    config.site_key        = settings[:site_key]
    config.secret_key      = settings[:secret_key]
    config.skip_verify_env = %w[development test cucumber]
  end
end
