# frozen_string_literal: true

class RemovePassportConfirmations < ActiveRecord::Migration[6.0]
  def change
    drop_table :passport_confirmations
    remove_column :passports, :confirmed
  end
end
