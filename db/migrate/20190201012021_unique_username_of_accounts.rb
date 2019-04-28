# frozen_string_literal: true

class UniqueUsernameOfAccounts < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :username, :string, null: false,
                                                 index: { unique: true }
  end
end
