# frozen_string_literal: true

FactoryBot.define do
  factory :regional_office do
    association :country_state
  end
end
