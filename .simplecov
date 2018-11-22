# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_filter '/factories/'
  add_filter '/spec/'

  add_group 'Channels', '/app/channels/'
end
