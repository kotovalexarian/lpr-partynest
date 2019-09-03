# frozen_string_literal: true

if $coverage
  SimpleCov.start 'rails' do
    merge_timeout 3600

    formatter SimpleCov::Formatter::HTMLFormatter

    add_group 'Interactors', '/app/interactors/'
    add_group 'Policies',    '/app/policies/'
    add_group 'Primitives',  '/app/primitives/'
    add_group 'Validators',  '/app/validators/'

    add_filter '/factories/'
    add_filter '/features/'
    add_filter '/lib/partynest/migration.rb'
    add_filter '/lib/partynest/rspec_account_role_helpers.rb'
    add_filter '/lib/templates/'
    add_filter '/spec/'
    add_filter '/vendor/'
  end
end
