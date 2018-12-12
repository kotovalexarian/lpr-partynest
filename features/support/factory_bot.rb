# frozen_string_literal: true

World FactoryBot::Syntax::Methods

DatabaseCleaner.cleaning do
  FactoryBot.lint strategy: :create, traits: true
end
