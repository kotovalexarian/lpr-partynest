# frozen_string_literal: true

FactoryBot.define do
  factory :some_relation_status, class: RelationStatus do
    association :org_unit_kind, factory: :some_children_org_unit_kind

    codename { Faker::Internet.unique.username 3..36, %w[_] }
    name { Faker::Company.unique.name }
  end

  factory :supporter_relation_status, class: RelationStatus do
    initialize_with do
      RelationStatus.find_or_initialize_by codename: codename
    end

    codename { :supporter }
    name { 'Сторонник' }

    association :org_unit_kind, factory: :reg_dept_org_unit_kind
  end

  factory :active_member_relation_status,
          parent: :supporter_relation_status do
    codename { :active_member }
    name { 'Член' }

    association :org_unit_kind, factory: :reg_dept_org_unit_kind
  end

  factory :pending_member_relation_status,
          parent: :supporter_relation_status do
    codename { :pending_member }
    name { 'Приостановленный член' }

    association :org_unit_kind, factory: :reg_dept_org_unit_kind
  end

  factory :exited_supporter_relation_status,
          parent: :supporter_relation_status do
    codename { :exited_supporter }
    name { 'Вышедший сторонник' }

    association :org_unit_kind, factory: :lpr_org_unit_kind
  end

  factory :exited_member_relation_status,
          parent: :supporter_relation_status do
    codename { :exited_member }
    name { 'Вышедший член' }

    association :org_unit_kind, factory: :lpr_org_unit_kind
  end

  factory :excluded_supporter_relation_status,
          parent: :supporter_relation_status do
    codename { :excluded_supporter }
    name { 'Исключённый сторонник' }

    association :org_unit_kind, factory: :lpr_org_unit_kind
  end

  factory :excluded_member_relation_status,
          parent: :supporter_relation_status do
    codename { :excluded_member }
    name { 'Исключённый член' }

    association :org_unit_kind, factory: :lpr_org_unit_kind
  end

  factory :fed_secretary_relation_status, parent: :supporter_relation_status do
    codename { :fed_secretary }
    name { 'Федеральный секретарь' }

    association :org_unit_kind, factory: :fed_management_org_unit_kind
  end

  factory :reg_secretary_relation_status, parent: :supporter_relation_status do
    codename { :reg_secretary }
    name { 'Секретарь РК РО' }

    association :org_unit_kind, factory: :reg_management_org_unit_kind
  end

  factory :fed_manager_relation_status, parent: :supporter_relation_status do
    codename { :fed_manager }
    name { 'Член ФК' }

    association :org_unit_kind, factory: :fed_management_org_unit_kind
  end

  factory :reg_manager_relation_status, parent: :supporter_relation_status do
    codename { :reg_manager }
    name { 'Член РК РО' }

    association :org_unit_kind, factory: :reg_management_org_unit_kind
  end

  factory :fed_supervisor_relation_status, parent: :supporter_relation_status do
    codename { :fed_supervisor }
    name { 'Член ЦКРК' }

    association :org_unit_kind, factory: :fed_supervision_org_unit_kind
  end

  factory :reg_supervisor_relation_status, parent: :supporter_relation_status do
    codename { :reg_supervisor }
    name { 'Член РКРК' }

    association :org_unit_kind, factory: :reg_supervision_org_unit_kind
  end
end
