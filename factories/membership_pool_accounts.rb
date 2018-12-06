# frozen_string_literal: true

FactoryBot.define do
  factory :membership_pool_account do
    association :membership_pool
    association :account, factory: :account_with_user
  end
end
