# frozen_string_literal: true

Cucumber::Rails::Database.autorun_database_cleaner = false
Cucumber::Rails::World.use_transactional_tests = false

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end

# You may also want to configure DatabaseCleaner to use different strategies
# for certain features and scenarios. See the DatabaseCleaner documentation
# for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { except: [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('not @no-txn', 'not @selenium', 'not @culerity', 'not @celerity',
#          'not @javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#
