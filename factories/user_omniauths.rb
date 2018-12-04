# frozen_string_literal: true

FactoryBot.define do
  factory :user_omniauth do
    association :user

    provider { 'github' }
    remote_id { SecureRandom.hex }
    email { Faker::Internet.email }
  end
end
