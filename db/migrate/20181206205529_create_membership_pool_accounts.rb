# frozen_string_literal: true

class CreateMembershipPoolAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_pool_accounts do |t|
      t.timestamps null: false

      t.references :membership_pool, null: false, foreign_key: true
      t.references :account,         null: false, foreign_key: true

      t.index %i[membership_pool_id account_id],
              name: 'index_membership_pool_accounts_on_pool_and_account',
              unique: true
    end
  end
end
