# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Elasticsearch::Model.client = Elasticsearch::Client.new(
  scheme: :http,
  host: '127.0.0.1',
  port: 9200,
  user: 'elastic',
  password: 'changeme',

  transport_options: {
    request: { timeout: 5 },
    ssl: { ca_file: nil },
  },
)
