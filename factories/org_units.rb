# frozen_string_literal: true

FactoryBot.define do
  factory :some_root_org_unit, class: OrgUnit do
    short_name { name }
    name { Faker::Company.unique.name }

    association :kind, factory: :some_root_org_unit_kind

    trait :with_parent do
      association :kind, factory: :some_children_org_unit_kind

      parent_unit { create :some_root_org_unit, kind: kind.parent_kind }
    end
  end

  factory :some_children_org_unit,
          parent: :some_root_org_unit,
          traits: %i[with_parent]
end
