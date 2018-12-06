# frozen_string_literal: true

FactoryBot.define do
  factory :membership_pool_app do
    association :membership_pool
    association :membership_app
  end
end
