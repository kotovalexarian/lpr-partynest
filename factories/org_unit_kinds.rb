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

  factory :lpr_org_unit_kind, class: OrgUnitKind do
    initialize_with do
      OrgUnitKind.find_or_initialize_by codename: codename
    end

    codename { :lpr }
    short_name { 'ЛПР' }
    name { 'Либертарианская партия России' }
  end

  factory :reg_dept_org_unit_kind, parent: :lpr_org_unit_kind do
    codename { :reg_dept }
    short_name { 'РО' }
    name { 'Региональное отделение' }
    resource_type { 'FederalSubject' }

    association :parent_kind, factory: :lpr_org_unit_kind
  end

  factory :fed_management_org_unit_kind, parent: :lpr_org_unit_kind do
    codename { :fed_management }
    short_name { 'ФК' }
    name { 'Федеральный комитет' }

    association :parent_kind, factory: :lpr_org_unit_kind
  end

  factory :fed_supervision_org_unit_kind, parent: :lpr_org_unit_kind do
    codename { :fed_supervision }
    short_name { 'ЦКРК' }
    name { 'Центральная контрольно-ревизионная комиссия' }

    association :parent_kind, factory: :lpr_org_unit_kind
  end

  factory :reg_management_org_unit_kind, parent: :lpr_org_unit_kind do
    codename { :reg_management }
    short_name { 'РК РО' }
    name { 'Руководящий комитет регионального отделения' }

    association :parent_kind, factory: :reg_dept_org_unit_kind
  end

  factory :reg_supervision_org_unit_kind, parent: :lpr_org_unit_kind do
    codename { :reg_supervision }
    short_name { 'РКРК' }
    name { 'Региональная контрольно-ревизионная комиссия' }

    association :parent_kind, factory: :reg_dept_org_unit_kind
  end
end
