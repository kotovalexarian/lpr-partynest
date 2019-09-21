# frozen_string_literal: true

FactoryBot.define do
  factory :some_relation_transition, class: RelationTransition do
    association :from_status, factory: :some_relation_status
    association :to_status,   factory: :some_relation_status

    name { Faker::Company.unique.name }
  end
end
