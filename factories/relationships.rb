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

  factory :excluded_relationship, parent: :some_children_relationship do
    association :org_unit, factory: :lpr_org_unit
    association :status, factory: :excluded_member_relation_status
    parent_rel { nil }
  end

  factory :included_relationship, parent: :some_children_relationship do
    association :org_unit, factory: :lpr_org_unit
    association :status, factory: :included_relation_status
    parent_rel { nil }
  end

  factory :supporter_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :moscow_reg_dept_org_unit
    association :status, factory: :supporter_relation_status
    association :parent_rel, factory: :included_relationship
  end

  factory :member_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :moscow_reg_dept_org_unit
    association :status, factory: :active_member_relation_status
    association :parent_rel, factory: :included_relationship
  end

  factory :federal_manager_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :fed_management_org_unit
    association :status, factory: :fed_manager_relation_status
    association :parent_rel, factory: :included_relationship
  end

  factory :federal_supervisor_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :fed_supervision_org_unit
    association :status, factory: :fed_supervisor_relation_status
    association :parent_rel, factory: :included_relationship
  end

  factory :regional_manager_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :moscow_reg_management_org_unit
    association :status, factory: :reg_manager_relation_status
    association :parent_rel, factory: :member_relationship
  end

  factory :regional_supervisor_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :moscow_reg_supervision_org_unit
    association :status, factory: :reg_supervisor_relation_status
    association :parent_rel, factory: :member_relationship
  end

  factory :federal_secretary_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :fed_management_org_unit
    association :status, factory: :fed_secretary_relation_status
    association :parent_rel, factory: :included_relationship
  end

  factory :regional_secretary_relationship, parent: :excluded_relationship do
    association :org_unit, factory: :moscow_reg_management_org_unit
    association :status, factory: :reg_secretary_relation_status
    association :parent_rel, factory: :member_relationship
  end
end
