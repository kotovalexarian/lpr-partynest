# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config.i18n.default_locale = :ru
Rails.application.config.i18n.available_locales = %i[en ru]
Rails.application.config.i18n.load_path +=
  Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
