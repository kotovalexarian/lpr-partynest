# frozen_string_literal: true

class CreateMembershipPools < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_pools do |t|
      t.timestamps null: false
      t.string :name, null: false
    end
  end
end
