# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

conf = Rails.application.settings :elasticsearch

Elasticsearch::Model.client = Elasticsearch::Client.new(
  scheme: conf[:ssl] ? :https : :http,
  host: String(conf[:host]),
  port: Integer(conf[:port]),
  user: String(conf[:user]),
  password: String(conf[:password]),

  transport_options: {
    request: { timeout: 5 },
    ssl: { ca_file: conf.dig(:ssl_params, :ca_file) },
  },
)
