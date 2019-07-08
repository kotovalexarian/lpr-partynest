# frozen_string_literal: true

class RemoveIndexAccountRolesOnAccountIdAndRoleId < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        remove_index :account_roles, %i[account_id role_id]
      end

      dir.down do
        add_index :account_roles, %i[account_id role_id], unique: true
      end
    end
  end
end
