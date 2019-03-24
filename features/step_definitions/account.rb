# frozen_string_literal: true

When 'there is an account with the following data:' do |table|
  options = table.raw.map { |(k, v)| [k.to_sym, v] }.to_h

  create :personal_account,
         username:    options[:username],
         public_name: options[:public_name],
         biography:   options[:biography]
end
