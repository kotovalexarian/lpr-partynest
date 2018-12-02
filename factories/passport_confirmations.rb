# frozen_string_literal: true

FactoryBot.define do
  factory :passport_confirmation do
    association :passport, factory: :passport_with_image
    association :account,  factory: :account_with_user
  end
end
