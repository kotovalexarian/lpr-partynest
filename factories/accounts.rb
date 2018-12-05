# frozen_string_literal: true

FactoryBot.define do
  factory :empty_account, class: Account

  factory :account_with_user, parent: :empty_account do
    association :user
  end
end
