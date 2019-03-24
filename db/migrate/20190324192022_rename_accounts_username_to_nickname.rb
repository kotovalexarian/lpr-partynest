# frozen_string_literal: true

class RenameAccountsUsernameToNickname < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :username, :nickname
  end
end
