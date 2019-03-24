# frozen_string_literal: true

When 'there is a usual account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  create :usual_account,
         username:    options[:username],
         public_name: options[:public_name],
         biography:   options[:biography]
end

When 'there is a supporter account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  country_state = create :country_state, name: options[:country_state]
  regional_office = create :regional_office, country_state: country_state
  person = create :supporter_person, regional_office: regional_office

  create :personal_account,
         username:    options[:username],
         public_name: options[:public_name],
         biography:   options[:biography],
         person:      person
end

When 'there is a member account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  country_state = create :country_state, name: options[:country_state]
  regional_office = create :regional_office, country_state: country_state
  person = create :member_person, regional_office: regional_office

  create :personal_account,
         username:    options[:username],
         public_name: options[:public_name],
         biography:   options[:biography],
         person:      person
end

When 'there is an excluded member account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  country_state = create :country_state, name: options[:country_state]
  regional_office = create :regional_office, country_state: country_state
  person = create :excluded_person, regional_office: regional_office

  create :personal_account,
         username:    options[:username],
         public_name: options[:public_name],
         biography:   options[:biography],
         person:      person
end
