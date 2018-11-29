# frozen_string_literal: true

class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.timestamps null: false
      t.string :name
      t.references :resource, polymorphic: true

      t.index %i[name resource_type resource_id], unique: true
    end

    create_table :user_roles do |t|
      t.timestamps null: false
      t.references :user, null: false
      t.references :role, null: false

      t.index %i[user_id role_id], unique: true
    end

    add_foreign_key :user_roles, :users
    add_foreign_key :user_roles, :roles
  end
end
