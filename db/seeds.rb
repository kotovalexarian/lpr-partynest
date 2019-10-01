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
do |(codename, parent, short_name, name)|
  parent = parent.blank? ? nil : OrgUnitKind.find_by!(codename: parent.strip)

  codename.strip!
  short_name.strip!
  name.strip!

  next if OrgUnitKind.find_by codename: codename

  OrgUnitKind.create!(
    codename: codename,
    short_name: short_name,
    name: name,
    parent_kind: parent,
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
    new_relation_status.name = name
  end
end

csv_foreach :relation_transitions \
do |(from, to, name)|
  from.strip!
  to.strip!
  name.strip!

  from_status = RelationStatus.find_by! codename: from unless from.empty?
  to_status   = RelationStatus.find_by! codename: to

  RelationTransition.where(
    from_status: from_status,
    to_status: to_status,
  ).first_or_create! do |new_relation_transition|
    new_relation_transition.name = name
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
