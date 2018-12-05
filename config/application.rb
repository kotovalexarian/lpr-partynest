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
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Fully qualified domain name.
    config.site_domain = 'libertarian-party.com'

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.factory_bot dir: 'factories'
    end
  end
end
