# frozen_string_literal: true

require 'csv'

def csv_foreach(filename, &block)
  CSV.foreach(
    Rails.root.join('db', 'data', "#{filename}.csv"),
    col_sep: '|',
    &block
  )
end

csv_foreach :federal_subjects \
do |(id, english_name, native_name, number, timezone, centre)|
  id = Integer(id.strip)
  english_name.strip!
  native_name.strip!
  number = Integer(number.strip.sub(/\A0*/, ''))
  timezone.strip!
  centre.strip!

  FederalSubject.where(id: id).first_or_create! do |new_federal_subject|
    new_federal_subject.english_name = english_name
    new_federal_subject.native_name = native_name
    new_federal_subject.number = number
    new_federal_subject.timezone = timezone
    new_federal_subject.centre = centre
  end
end

csv_foreach :contact_networks \
do |(id, codename, name)|
  id = Integer(id.strip)
  codename.strip!
  name.strip!

  ContactNetwork.where(id: id).first_or_create! do |new_contact_network|
    new_contact_network.codename = codename
    new_contact_network.name = name
  end
end

csv_foreach :org_unit_kinds \
do |(codename, parent, short_name, name, resource_type)|
  parent = parent.blank? ? nil : OrgUnitKind.find_by!(codename: parent.strip)

  codename.strip!
  short_name.strip!
  name.strip!
  resource_type = resource_type.strip.presence

  next if OrgUnitKind.find_by codename: codename

  OrgUnitKind.create!(
    codename: codename,
    short_name: short_name,
    name: name,
    parent_kind: parent,
    resource_type: resource_type,
  )
end

csv_foreach :relation_statuses \
do |(org_unit_kind, codename, name)|
  org_unit_kind =
    if org_unit_kind.blank?
      nil
    else
      OrgUnitKind.find_by!(codename: org_unit_kind.strip)
    end

  codename.strip!
  name.strip!

  RelationStatus.where(codename: codename).first_or_create! \
  do |new_relation_status|
    new_relation_status.org_unit_kind = org_unit_kind
    new_relation_status.name = name
  end
end

Rails.application.settings(:superuser).tap do |config|
  user = User.where(email: config[:email]).first_or_create! do |new_user|
    new_user.password = config[:password]
    new_user.confirmed_at = Time.zone.now
    new_user.account = Account.create!(
      nickname: config[:nickname],
      public_name: config[:public_name],
      biography: config[:biography],
      contact_list: ContactList.new,
    )
  end

  user.account.update! superuser: true
end

lpr_org_unit_kind             = OrgUnitKind.find_by! codename: :lpr
reg_dept_org_unit_kind        = OrgUnitKind.find_by! codename: :reg_dept
fed_management_org_unit_kind  = OrgUnitKind.find_by! codename: :fed_management
fed_supervision_org_unit_kind = OrgUnitKind.find_by! codename: :fed_supervision
reg_management_org_unit_kind  = OrgUnitKind.find_by! codename: :reg_management
reg_supervision_org_unit_kind = OrgUnitKind.find_by! codename: :reg_supervision

lpr_org_unit = OrgUnit.where(kind: lpr_org_unit_kind).first_or_create!(
  short_name: 'ЛПР',
  name: 'Либертарианская партия России',
)

OrgUnit.where(
  kind: fed_management_org_unit_kind,
  parent_unit: lpr_org_unit,
).first_or_create!(
  short_name: 'ФК ЛПР',
  name: 'Федеральный комитет Либертарианской партии России',
)

OrgUnit.where(
  kind: fed_supervision_org_unit_kind,
  parent_unit: lpr_org_unit,
).first_or_create!(
  short_name: 'ЦКРК ЛПР',
  name: 'Центральная контрольно-ревизионная комиссия ' \
        'Либертарианской партии России',
)

FederalSubject.all.each do |federal_subject|
  reg_dept_org_unit = OrgUnit.where(
    kind: reg_dept_org_unit_kind,
    parent_unit: lpr_org_unit,
    resource: federal_subject,
  ).first_or_create!(
    short_name: "РО ЛПР (#{federal_subject.native_name})",
    name: 'Региональное отделение Либертарианской партии России ' \
          "(#{federal_subject.native_name})",
  )

  OrgUnit.where(
    kind: reg_management_org_unit_kind,
    parent_unit: reg_dept_org_unit,
  ).first_or_create!(
    short_name: "РК РО ЛПР (#{federal_subject.native_name})",
    name: 'Руководящий комитет регионального отделения ' \
          "Либертарианской партии России (#{federal_subject.native_name})",
  )

  OrgUnit.where(
    kind: reg_supervision_org_unit_kind,
    parent_unit: reg_dept_org_unit,
  ).first_or_create!(
    short_name: "РКРК ЛПР (#{federal_subject.native_name})",
    name: 'Региональная контрольно-ревизионная комиссия' \
          "Либертарианской партии России (#{federal_subject.native_name})",
  )
end
