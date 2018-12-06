# frozen_string_literal: true

FactoryBot.define do
  factory :guest_account, class: Account

  factory :account_with_user, parent: :guest_account do
    association :user
  end

  factory :superuser_account, parent: :account_with_user do
    after :create do |account, _evaluator|
      account.add_role :superuser
    end
  end
end
