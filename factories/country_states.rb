# frozen_string_literal: true

FactoryBot.define do
  factory :country_state do
    name { Faker::Address.unique.state }
  end
end
