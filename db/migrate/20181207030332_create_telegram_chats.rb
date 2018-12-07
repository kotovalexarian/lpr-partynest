# frozen_string_literal: true

class CreateTelegramChats < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_chats do |t|
      t.timestamps null: false

      t.integer :remote_id, null: false, index: { unique: true }
      t.string  :chat_type, null: false

      t.string :title
      t.string :username
      t.string :first_name
      t.string :last_name
    end
  end
end
