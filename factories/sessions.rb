# frozen_string_literal: true

FactoryBot.define do
  factory :some_session, class: Session do
    association :account, factory: :usual_account

    logged_at { Faker::Time.backward.utc }

    ip_address { Faker::Internet.ip_v4_address }

    trait :with_ipv6_address do
      ip_address { Faker::Internet.ip_v6_address }
    end
  end

  factory :some_session_with_ipv4_address,
          parent: :some_session,
          traits: %i[with_ipv6_address]
end
