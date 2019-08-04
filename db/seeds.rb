# frozen_string_literal: true

require 'csv'

federal_subjects_filename = Rails.root.join 'config', 'federal_subjects.csv'
contact_networks_filename = Rails.root.join 'config', 'contact_networks.csv'

CSV.foreach(
  federal_subjects_filename,
  col_sep: '|',
) do |(id, english_name, native_name, number, timezone, centre)|
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

CSV.foreach(
  contact_networks_filename,
  col_sep: '|',
) do |(id, nickname, public_name)|
  id = Integer(id.strip)
  nickname.strip!
  public_name.strip!

  ContactNetwork.where(id: id).first_or_create! do |new_contact_network|
    new_contact_network.nickname = nickname
    new_contact_network.public_name = public_name
  end
end

Rails.application.settings(:superuser).tap do |config|
  User.where(email: config[:email]).first_or_create! do |new_user|
    new_user.password = config[:password]
    new_user.confirmed_at = Time.zone.now
    new_user.account = Account.create!(
      nickname: config[:nickname],
      public_name: config[:public_name],
      biography: config[:biography],
    )
  end.account.add_role :superuser
end
