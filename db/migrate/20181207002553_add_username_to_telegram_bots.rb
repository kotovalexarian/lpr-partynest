# frozen_string_literal: true

class AddUsernameToTelegramBots < ActiveRecord::Migration[5.2]
  def change
    add_column :telegram_bots, :username, :string, index: true
  end
end
