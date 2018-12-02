# frozen_string_literal: true

class MoveFromUsersToAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :passport_confirmations, :users
    remove_foreign_key :user_roles,             :users

    rename_table :user_roles, :account_roles

    rename_column :passport_confirmations, :user_id, :account_id
    rename_column :account_roles,          :user_id, :account_id

    add_foreign_key :passport_confirmations, :accounts
    add_foreign_key :account_roles,          :accounts
  end
end
