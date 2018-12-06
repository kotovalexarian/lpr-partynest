# frozen_string_literal: true

class CreateMembershipPoolApps < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_pool_apps do |t|
      t.timestamps null: false

      t.references :membership_pool, null: false, foreign_key: true
      t.references :membership_app,  null: false, foreign_key: true

      t.index %i[membership_app_id membership_pool_id],
              name:   'index_membership_pool_apps_on_app_and_pool',
              unique: true
    end
  end
end
