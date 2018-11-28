# frozen_string_literal: true

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
])

SimpleCov.start 'rails' do
  add_filter '/factories/'
  add_filter '/spec/'

  add_group 'Channels', '/app/channels/'
end
