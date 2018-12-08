# frozen_string_literal: true

FactoryBot.define do
  factory :passport_confirmation do
    association :passport, factory: :passport_with_passport_map_and_image
    association :account,  factory: :usual_account
  end
end
