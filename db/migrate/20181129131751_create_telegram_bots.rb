# frozen_string_literal: true

class CreateTelegramBots < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_bots do |t|
      t.timestamps null: false
      t.string :secret, null: false
    end
  end
end
