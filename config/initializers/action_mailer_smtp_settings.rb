# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

conf = Rails.application.settings :smtp

ActionMailer::Base.smtp_settings = {
  address: conf[:address],
  port: conf[:port]&.to_i,
  domain: conf[:domain],
  user_name: conf[:user_name],
  password: conf[:password],
  authentication: conf[:authentication]&.to_sym,
  enable_starttls_auto: conf[:enable_starttls_auto],
  openssl_verify_mode: conf[:openssl_verify_mode],
}.compact.presence
