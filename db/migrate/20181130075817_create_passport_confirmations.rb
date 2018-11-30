# frozen_string_literal: true

class CreatePassportConfirmations < ActiveRecord::Migration[5.2]
  def change
    create_table :passport_confirmations do |t|
      t.timestamps null: false
      t.references :passport, null: false, foreign_key: true
      t.references :user,     null: false, foreign_key: true

      t.index %i[passport_id user_id], unique: true
    end
  end
end
