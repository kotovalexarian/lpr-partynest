# frozen_string_literal: true

FactoryBot.define do
  factory :country_state do
    initialize_with do
      CountryState.find_or_initialize_by english_name: english_name
    end

    english_name { Faker::Address.unique.state }
    native_name { english_name }
  end
end
