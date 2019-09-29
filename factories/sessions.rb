# frozen_string_literal: true

FactoryBot.define do
  factory :some_session, class: Session do
    association :account, factory: :usual_account

    logged_at { Faker::Time.backward.utc }

    ip_address { Faker::Internet.ip_v4_address }

    user_agent { Faker::Internet.user_agent }

    trait :with_ipv6_address do
      ip_address { Faker::Internet.ip_v6_address }
    end

    trait :without_user_agent do
      user_agent { nil }
    end
  end

  factory :some_session_with_ipv6_address,
          parent: :some_session,
          traits: %i[with_ipv6_address]
end
