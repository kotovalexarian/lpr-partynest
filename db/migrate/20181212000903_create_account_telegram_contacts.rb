# frozen_string_literal: true

class CreateAccountTelegramContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :account_telegram_contacts do |t|
      t.timestamps null: false

      t.references :account,
                   null:        false,
                   foreign_key: true

      t.references :telegram_chat,
                   null:        false,
                   index:       { unique: true },
                   foreign_key: true
    end
  end
end
