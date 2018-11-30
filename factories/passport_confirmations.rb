# frozen_string_literal: true

FactoryBot.define do
  factory :passport_confirmation do
    passport
    user
  end
end
