# frozen_string_literal: true

class AddDeletedAtToAccountRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :account_roles, :deleted_at, :datetime
  end
end
