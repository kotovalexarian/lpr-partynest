# frozen_string_literal: true

# This should be on the top of the file.
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production or staging
if Rails.env.production? || Rails.env.staging?
  abort 'The Rails environment is running in production or staging mode!'
end

require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

require 'partynest/rspec_account_role_helpers'

require_relative 'support/shoulda_matchers'
require_relative 'support/faker'
require_relative 'support/factory_bot'
require_relative 'support/database_cleaner'
require_relative 'support/devise'
require_relative 'support/pundit'
require_relative 'support/webmock'

require_relative 'models/shared_examples/nameable'
require_relative 'models/shared_examples/required_nameable'

require_relative 'requests/shared_examples/paginal_controller'

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

ActiveJob::Base.queue_adapter = :test

Rack::Attack.enabled = false

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('fixtures').to_s

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Partynest::RSpecAccountRoleHelpers
  config.extend  Partynest::RSpecAccountRoleHelpers::ClassMethods
end
