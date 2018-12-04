# frozen_string_literal: true

country_states_filename = Rails.root.join 'config', 'country_states.txt'

country_state_names = File.readlines(country_states_filename).map(&:strip)

country_state_names.each do |name|
  next if CountryState.where(name: name).exists?

  CountryState.create! name: name
end

admin_account = Account.create!
admin_account.add_role :superuser
admin_account.create_user!(
  email:        Rails.application.credentials.initial_admin_email,
  password:     Rails.application.credentials.initial_admin_password,
  confirmed_at: Time.zone.now,
)
