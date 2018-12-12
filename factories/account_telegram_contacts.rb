# frozen_string_literal: true

FactoryBot.define do
  factory :account_telegram_contact do
    association :account, factory: :guest_account
    association :telegram_chat
  end
end
