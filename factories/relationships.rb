# frozen_string_literal: true

FactoryBot.define do
  factory :some_root_relationship, class: Relationship do
    association :org_unit, factory: :some_root_org_unit
    association :status, factory: :some_relation_status
    association :person, factory: :initial_person

    sequence :from_date do |n|
      Date.new rand((10 * n)...(11 * n)), rand(1..12), rand(1..28)
    end

    trait :with_parent do
      association :org_unit, factory: :some_children_org_unit

      parent_rel do
        create :some_root_relationship, org_unit: org_unit&.parent_unit
      end
    end
  end

  factory :some_children_relationship,
          parent: :some_root_relationship,
          traits: %i[with_parent]

  factory :supporter_relationship, parent: :some_children_relationship

  factory :excluded_relationship, parent: :supporter_relationship

  factory :member_relationship, parent: :supporter_relationship

  factory :federal_manager_relationship, parent: :member_relationship

  factory :federal_supervisor_relationship, parent: :member_relationship

  factory :regional_manager_relationship, parent: :member_relationship

  factory :regional_supervisor_relationship, parent: :member_relationship

  factory :federal_secretary_relationship,
          parent: :federal_manager_relationship

  factory :regional_secretary_relationship,
          parent: :regional_manager_relationship
end
