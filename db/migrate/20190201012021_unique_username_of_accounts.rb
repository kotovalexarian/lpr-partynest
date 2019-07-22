# frozen_string_literal: true

class UniqueUsernameOfAccounts < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :accounts, :username, :string, null: false,
                                                     index: { unique: true }
      end

      dir.down do
        change_column :accounts, :username, :string, null: false,
                                                     index: { unique: false }
      end
    end
  end
end
