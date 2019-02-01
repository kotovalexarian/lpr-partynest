# frozen_string_literal: true

class AddUsernameToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :username, :string, index: { unique: true }
  end
end
