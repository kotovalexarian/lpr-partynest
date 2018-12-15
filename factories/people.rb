# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    association :regional_office
  end
end
