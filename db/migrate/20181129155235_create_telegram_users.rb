# frozen_string_literal: true

class CreateTelegramUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_users do |t|
      t.timestamps null: false
      t.integer :remote_telegram_id, null: false
      t.boolean :is_bot, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.string :username
      t.string :language_code

      t.index :remote_telegram_id, unique: true
    end
  end
end
