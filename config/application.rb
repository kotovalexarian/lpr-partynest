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
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, :staging, or :production.
Bundler.require(*Rails.groups)

require 'elasticsearch/rails/instrumentation'

require 'csv'

module Partynest
  class Application < Rails::Application
    FILTER_PARAMS = %i[
      api_token
      confirmation_token
      password
      password_confirmation
      reset_password_token
      secret
      unlock_token
    ].freeze

    def restricted?
      if instance_variable_defined? :@partynest_restricted
        return @partynest_restricted
      end

      @partynest_restricted =
        case ENV['PARTYNEST_RESTRICT']
        when nil, 'no' then false
        when 'yes'     then true
        else
          raise 'Invalid value for ENV "PARTYNEST_RESTRICT"'
        end
    end

    def settings(name)
      name = String(name).to_sym
      raise "Invalid name: #{name.to_s.inspect}" unless name.match?(/\A\w+\z/)

      @partynest_settings ||= {}

      @partynest_settings[name] ||=
        config_for("settings/#{name}").deep_symbolize_keys.freeze
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += [
      config.root.join('app', 'primitives'),
      config.root.join('app', 'validators'),
      config.root.join('lib'),
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
