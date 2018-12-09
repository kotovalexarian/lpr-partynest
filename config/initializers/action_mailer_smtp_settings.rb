# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config_for(:smtp).deep_symbolize_keys.tap do |config|
  ActionMailer::Base.smtp_settings = {
    address:              config[:address],
    port:                 config[:port]&.to_i,
    domain:               config[:domain],
    user_name:            config[:user_name],
    password:             config[:password],
    authentication:       config[:authentication]&.to_sym,
    enable_starttls_auto: config[:enable_starttls_auto],
    openssl_verify_mode:  config[:openssl_verify_mode],
  }
end
