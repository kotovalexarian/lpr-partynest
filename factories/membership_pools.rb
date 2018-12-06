# frozen_string_literal: true

FactoryBot.define do
  factory :membership_pool do
    name { Faker::Lorem.sentence[0...-1] }
  end
end
