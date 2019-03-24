# frozen_string_literal: true

require 'csv'

country_states_filename = Rails.root.join 'config', 'country_states.csv'

CSV.foreach country_states_filename,
            col_sep: '|' do |(native_name, english_name)|
  native_name.strip!
  english_name.strip!

  next if CountryState.where(english_name: english_name).exists?

  CountryState.create! english_name: english_name, native_name: native_name
end

Rails.application.settings(:superuser).tap do |config|
  User.where(email: config[:email]).first_or_create! do |new_user|
    new_user.password = config[:password]
    new_user.confirmed_at = Time.zone.now
    new_user.account = Account.create!(
      nickname:    config[:nickname],
      public_name: config[:public_name],
      biography:   config[:biography],
    )
  end.account.add_role :superuser
end
