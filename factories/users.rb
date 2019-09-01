# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :account, factory: :initial_account

    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }

    after :create do |user, _evaluator|
      user.confirm
    end
  end
end
