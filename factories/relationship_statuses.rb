# frozen_string_literal: true

FactoryBot.define do
  factory :relationship_status do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
  end
end
