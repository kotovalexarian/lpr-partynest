# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_bot do
    secret { SecureRandom.hex }
  end
end
