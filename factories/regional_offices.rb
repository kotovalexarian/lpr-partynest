# frozen_string_literal: true

FactoryBot.define do
  factory :regional_office do
    initialize_with do
      RegionalOffice.find_or_initialize_by country_state: country_state
    end

    association :country_state
  end
end
