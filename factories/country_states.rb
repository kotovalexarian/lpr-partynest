# frozen_string_literal: true

FactoryBot.define do
  factory :country_state do
    initialize_with do
      CountryState.find_or_initialize_by name: name
    end

    name { Faker::Address.unique.state }
    english_name { Faker::Address.unique.state }
  end
end
