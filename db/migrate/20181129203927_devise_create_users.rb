# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.timestamps null: false
    end

    create_table :users do |t|
      t.timestamps null: false

      t.references :account, null: false

      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      t.index :account_id,           unique: true
      t.index :email,                unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token,   unique: true
      t.index :unlock_token,         unique: true
    end

    create_table :roles do |t|
      t.timestamps null: false
      t.string :name
      t.references :resource, polymorphic: true

      t.index %i[name resource_type resource_id], unique: true
    end

    create_table :account_roles do |t|
      t.timestamps null: false
      t.references :account, null: false
      t.references :role, null: false

      t.index %i[account_id role_id], unique: true
    end

    create_table :country_states do |t|
      t.timestamps null: false
      t.string :name, null: false

      t.index :name, unique: true
    end

    add_foreign_key :users,         :accounts
    add_foreign_key :account_roles, :accounts
    add_foreign_key :account_roles, :roles
  end
end
