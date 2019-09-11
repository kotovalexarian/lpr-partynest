# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before :suite do
    ActiveRecord::Base.transaction do
      FactoryBot.lint strategy: :create, traits: true
    end
  end
end
