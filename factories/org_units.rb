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

  factory :lpr_org_unit, class: OrgUnit do
    initialize_with do
      OrgUnit.find_or_initialize_by short_name: short_name
    end

    short_name { 'ЛПР' }
    name { 'Либертарианская партия России' }

    association :kind, factory: :lpr_org_unit_kind
  end

  factory :moscow_reg_dept_org_unit, parent: :lpr_org_unit do
    short_name { 'РО ЛПР в Москве' }
    name { 'Региональное отделение Либертарианской партии России в Москве' }

    association :kind, factory: :reg_dept_org_unit_kind
    association :parent_unit, factory: :lpr_org_unit
  end

  factory :perm_reg_dept_org_unit, parent: :lpr_org_unit do
    short_name { 'РО ЛПР в Пермском крае' }

    name do
      'Региональное отделение Либертарианской партии России в Пермском крае'
    end

    association :kind, factory: :reg_dept_org_unit_kind
    association :parent_unit, factory: :lpr_org_unit
  end

  factory :fed_management_org_unit, parent: :lpr_org_unit do
    short_name { 'ФК ЛПР' }
    name { 'Федеральный комитет Либертарианской партии России' }

    association :kind, factory: :fed_management_org_unit_kind
    association :parent_unit, factory: :lpr_org_unit
  end

  factory :fed_supervision_org_unit, parent: :lpr_org_unit do
    short_name { 'ЦКРК ЛПР' }

    name do
      'Центральная контрольно-ревизионная комиссия ' \
        'Либертарианской партии России'
    end

    association :kind, factory: :fed_supervision_org_unit_kind
    association :parent_unit, factory: :lpr_org_unit
  end

  factory :moscow_reg_management_org_unit, parent: :lpr_org_unit do
    short_name { 'РК РО ЛПР в Москве' }

    name do
      'Руководящий комитет регионального отделения ' \
        'Либертарианской партии России в Москве'
    end

    association :kind, factory: :reg_management_org_unit_kind
    association :parent_unit, factory: :moscow_reg_dept_org_unit
  end

  factory :moscow_reg_supervision_org_unit, parent: :lpr_org_unit do
    short_name { 'РКРК ЛПР в Москве' }

    name do
      'Региональная контрольно-ревизионная комиссия' \
        'Либертарианской партии России в Москве'
    end

    association :kind, factory: :reg_supervision_org_unit_kind
    association :parent_unit, factory: :moscow_reg_dept_org_unit
  end

  factory :perm_reg_management_org_unit, parent: :lpr_org_unit do
    short_name { 'РК РО ЛПР в Пермском крае' }

    name do
      'Руководящий комитет регионального отделения ' \
        'Либертарианской партии России в Пермском крае'
    end

    association :kind, factory: :reg_management_org_unit_kind
    association :parent_unit, factory: :perm_reg_dept_org_unit
  end

  factory :perm_reg_supervision_org_unit, parent: :lpr_org_unit do
    short_name { 'РКРК ЛПР в Пермском крае' }

    name do
      'Региональная контрольно-ревизионная комиссия' \
        'Либертарианской партии России в Пермском крае'
    end

    association :kind, factory: :reg_supervision_org_unit_kind
    association :parent_unit, factory: :perm_reg_dept_org_unit
  end
end
