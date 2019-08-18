# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'csv'

module Partynest
  class Application < Rails::Application
    FILTER_PARAMS = %i[
      api_token
      confirmation_token
      guest_token
      password
      password_confirmation
      reset_password_token
      secret
      unlock_token
    ].freeze

    def settings(name)
      config_for("settings/#{name}").deep_symbolize_keys
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += [
      config.root.join('app', 'validators'),
    ]

    # Use SQL format for database schema
    config.active_record.schema_format = :sql

    # Use Sidekiq as ActiveJob adapter.
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.assets false
      g.helper false
      g.system_tests nil

      g.factory_bot dir: 'factories'
    end
  end
end
