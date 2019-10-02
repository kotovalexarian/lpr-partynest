# frozen_string_literal: true

FactoryBot.define do
  factory :some_relation_status, class: RelationStatus do
    association :org_unit_kind, factory: :some_children_org_unit_kind

    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
  end
end
