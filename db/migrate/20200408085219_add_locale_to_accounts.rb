# frozen_string_literal: true

class AddLocaleToAccounts < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    add_enum :locale, %i[en ru]

    add_column :accounts, :locale, :locale, null: false, default: 'ru'
  end
end
