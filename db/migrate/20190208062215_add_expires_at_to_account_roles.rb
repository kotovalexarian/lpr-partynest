# frozen_string_literal: true

class AddExpiresAtToAccountRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :account_roles, :expires_at, :datetime
  end
end
