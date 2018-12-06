# frozen_string_literal: true

class RemovePools < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :membership_pool_apps
    drop_table :membership_pool_accounts
    drop_table :membership_pools
    # rubocop:enable Rails/ReversibleMigration
  end
end
