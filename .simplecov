# frozen_string_literal: true

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
])

SimpleCov.start 'rails' do
  add_group 'Channels',    '/app/channels/'
  add_group 'Interactors', '/app/interactors/'
  add_group 'Policies',    '/app/policies/'

  add_filter '/app/previews/'
  add_filter '/factories/'
  add_filter '/features/'
  add_filter '/lib/templates/'
  add_filter '/spec/'
  add_filter '/vendor/'
end
