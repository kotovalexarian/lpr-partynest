# frozen_string_literal: true

When 'there is a usual account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  create :usual_account,
         nickname: options[:nickname],
         public_name: options[:public_name],
         biography: options[:biography]
end

When 'there is a superuser account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  create :superuser_account,
         nickname: options[:nickname],
         public_name: options[:public_name],
         biography: options[:biography]
end

When 'there is a supporter account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  # federal_subject =
  #   create :federal_subject, english_name: options[:federal_subject]
  # regional_office = create :regional_office, federal_subject: federal_subject
  person = create :supporter_person # , regional_office: regional_office

  create :personal_account,
         nickname: options[:nickname],
         public_name: options[:public_name],
         biography: options[:biography],
         person: person
end

When 'there is an excluded member account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  # federal_subject =
  #   create :federal_subject, english_name: options[:federal_subject]
  # regional_office = create :regional_office, federal_subject: federal_subject
  person = create :excluded_person # , regional_office: regional_office

  create :personal_account,
         nickname: options[:nickname],
         public_name: options[:public_name],
         biography: options[:biography],
         person: person
end

When 'there is a member account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  person_factory = options[:factory].presence || :member_person

  # federal_subject =
  #   create :federal_subject, english_name: options[:federal_subject]
  # regional_office = create :regional_office, federal_subject: federal_subject
  person = create person_factory # , regional_office: regional_office

  create :personal_account,
         nickname: options[:nickname],
         public_name: options[:public_name],
         biography: options[:biography],
         person: person
end
