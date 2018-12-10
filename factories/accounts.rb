# frozen_string_literal: true

FactoryBot.define do
  factory :guest_account, class: Account

  factory :usual_account, parent: :guest_account do
    association :user
  end

  factory :personal_account, parent: :usual_account do
    association :person
  end

  factory :superuser_account, parent: :personal_account do
    after :create do |account, _evaluator|
      account.add_role :superuser
    end
  end
end
