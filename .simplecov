# frozen_string_literal: true

if $coverage
  SimpleCov.start 'rails' do
    merge_timeout 3600

    formatter SimpleCov::Formatter::HTMLFormatter

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
end
