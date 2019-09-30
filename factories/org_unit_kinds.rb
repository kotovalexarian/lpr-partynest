# frozen_string_literal: true

FactoryBot.define do
  factory :some_root_org_unit_kind, class: OrgUnitKind do
    codename { Faker::Internet.unique.username 3..36, %w[_] }
    short_name { name }
    name { Faker::Company.unique.name }

    trait :with_parent do
      association :parent_kind, factory: :some_root_org_unit_kind
    end
  end

  factory :some_children_org_unit_kind,
          parent: :some_root_org_unit_kind,
          traits: %i[with_parent]
end
