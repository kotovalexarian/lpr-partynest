# frozen_string_literal: true

country_states_filename = Rails.root.join 'config', 'country_states.txt'

country_state_names = File.readlines(country_states_filename).map(&:strip)

country_state_names.each do |name|
  next if CountryState.where(name: name).exists?

  CountryState.create! name: name
end
