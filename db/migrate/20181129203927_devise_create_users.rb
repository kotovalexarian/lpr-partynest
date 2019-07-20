# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :country_states do |t|
      t.timestamps null: false

      t.string :name, null: false

      t.index :name, unique: true
    end

    create_table :regional_offices do |t|
      t.timestamps null: false

      t.references :country_state, null: false, index: { unique: true }
    end

    create_table :people do |t|
      t.timestamps null: false
    end

    create_table :accounts do |t|
      t.timestamps null: false

      t.string :guest_token, null: false

      t.references :person, index: { unique: true }

      t.index :guest_token, unique: true
    end

    create_table :users do |t|
      t.timestamps null: false

      t.references :account, null: false, index: { unique: true }

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

      t.index :email,                unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token,   unique: true
      t.index :unlock_token,         unique: true
    end

    create_table :roles do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.references :resource, polymorphic: true

      t.index %i[name resource_type resource_id], unique: true
    end

    create_table :account_roles do |t|
      t.timestamps null: false
      t.references :account, null: false
      t.references :role, null: false

      t.index %i[account_id role_id], unique: true
    end

    create_table :user_omniauths do |t|
      t.timestamps null: false

      t.references :user, foreign_key: true
      t.string :provider,  null: false
      t.string :remote_id, null: false
      t.string :email,     null: false

      t.index %i[remote_id provider], unique: true
    end

    add_foreign_key :users,            :accounts
    add_foreign_key :account_roles,    :accounts
    add_foreign_key :account_roles,    :roles
    add_foreign_key :accounts,         :people
    add_foreign_key :regional_offices, :country_states
  end
end
