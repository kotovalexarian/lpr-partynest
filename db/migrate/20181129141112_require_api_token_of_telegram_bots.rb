# frozen_string_literal: true

class RequireApiTokenOfTelegramBots < ActiveRecord::Migration[5.2]
  def change
    change_column :telegram_bots, :api_token, :string, null: false
  end
end
