# frozen_string_literal: true

FactoryBot.define do
  factory :regional_office do
    initialize_with do
      RegionalOffice.find_or_initialize_by federal_subject: federal_subject
    end

    association :federal_subject
  end
end
