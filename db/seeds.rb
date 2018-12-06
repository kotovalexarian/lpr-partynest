# frozen_string_literal: true

country_states_filename = Rails.root.join 'config', 'country_states.txt'

country_state_names = File.readlines(country_states_filename).map(&:strip)

country_state_names.each do |name|
  next if CountryState.where(name: name).exists?

  CountryState.create! name: name
end

User.where(email: Rails.application.credentials.initial_superuser_email)
    .first_or_create! do |new_user|
  new_user.account = Account.create!
  new_user.password = Rails.application.credentials.initial_superuser_password
  new_user.confirmed_at = Time.zone.now
end.account.add_role :superuser
