# frozen_string_literal: true

class AddGuestTokenToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :guest_token, :string,
               null: false, # rubocop:disable Rails/NotNullColumn
               index: { unique: true }
  end
end
