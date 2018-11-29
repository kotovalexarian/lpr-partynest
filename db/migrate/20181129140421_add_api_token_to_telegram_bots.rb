# frozen_string_literal: true

class AddApiTokenToTelegramBots < ActiveRecord::Migration[5.2]
  def change
    add_column :telegram_bots, :api_token, :string
  end
end
