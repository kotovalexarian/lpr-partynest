# frozen_string_literal: true

country_states_filename = Rails.root.join 'config', 'country_states.txt'

country_state_names = File.readlines(country_states_filename).map(&:strip)

country_state_names.each do |name|
  next if CountryState.where(name: name).exists?

  CountryState.create! name: name
end

Rails.application.config_for(:superuser).deep_symbolize_keys.tap do |config|
  User.where(email: config[:email]).first_or_create! do |new_user|
    new_user.account = Account.create!
    new_user.password = config[:password]
    new_user.confirmed_at = Time.zone.now
  end.account.add_role :superuser
end
