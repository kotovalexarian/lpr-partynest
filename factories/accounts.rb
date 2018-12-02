# frozen_string_literal: true

FactoryBot.define do
  factory :account_with_user, class: Account do
    association :user
  end
end
