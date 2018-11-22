# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Faker::UniqueGenerator.clear
  end
end
