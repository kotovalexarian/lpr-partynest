# frozen_string_literal: true

require 'csv'

federal_subjects_filename = Rails.root.join 'config', 'federal_subjects.csv'

CSV.foreach federal_subjects_filename,
            col_sep: '|' do |(id, english_name, native_name, _number)|
  id = Integer(id.strip)
  english_name.strip!
  native_name.strip!

  FederalSubject.where(id: id).first_or_create! do |new_federal_subject|
    new_federal_subject.english_name = english_name
    new_federal_subject.native_name = native_name
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
