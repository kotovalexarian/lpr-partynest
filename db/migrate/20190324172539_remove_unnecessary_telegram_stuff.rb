# frozen_string_literal: true

class RemoveUnnecessaryTelegramStuff < ActiveRecord::Migration[6.0]
  def change
    drop_table :account_telegram_contacts
    drop_table :telegram_bots
    drop_table :telegram_chats
  end
end
