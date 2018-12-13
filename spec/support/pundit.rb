# frozen_string_literal: true

require 'pundit/matchers'

Pundit::Matchers.configure do |config|
  config.user_alias = :account
end
