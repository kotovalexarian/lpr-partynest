# frozen_string_literal: true

class RemoveUnnecessaryTelegramStuff < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :account_telegram_contacts
    drop_table :telegram_bots
    drop_table :telegram_chats
    # rubocop:enable Rails/ReversibleMigration
  end
end
