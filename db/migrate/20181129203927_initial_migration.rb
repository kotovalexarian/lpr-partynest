# frozen_string_literal: true

class InitialMigration < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TYPE sex AS ENUM ('male', 'female');

          CREATE TYPE relationship_status AS ENUM (
            'supporter',
            'excluded',
            'member'
          );

          CREATE TYPE relationship_role AS ENUM ('manager', 'supervisor');
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TYPE sex;
          DROP TYPE relationship_status;
          DROP TYPE relationship_role;
        SQL
      end
    end

    create_table :contacts_lists do |t|
      t.timestamps null: false
    end

    create_table :federal_subjects do |t|
      t.timestamps null: false

      t.string :english_name, null: false, index: { unique: true }
      t.string :native_name,  null: false, index: { unique: true }

      t.integer  :number,   null: false, index: { unique: true }
      t.interval :timezone, null: false, index: false
    end

    create_table :regional_offices do |t|
      t.timestamps null: false

      t.references :federal_subject, null: false, index: { unique: true }
    end

    create_table :people do |t|
      t.timestamps null: false

      t.string :first_name,     null: false
      t.string :middle_name,    null: true
      t.string :last_name,      null: false
      t.column :sex, :sex,      null: false
      t.date   :date_of_birth,  null: false
      t.string :place_of_birth, null: false

      t.references :contacts_list, null: false, index: { unique: true }
    end

    create_table :passports do |t|
      t.timestamps null: false

      t.string  :last_name,      null: false
      t.string  :first_name,     null: false
      t.string  :middle_name
      t.column  :sex, :sex,      null: false
      t.date    :date_of_birth,  null: false
      t.string  :place_of_birth, null: false
      t.integer :series,         null: false
      t.integer :number,         null: false
      t.text    :issued_by,      null: false
      t.string  :unit_code,      null: false
      t.date    :date_of_issue,  null: false

      t.references :person, index: true, foreign_key: true
    end

    create_table :accounts do |t|
      t.timestamps null: false

      t.string :guest_token, null: false, index: { unique: true }
      t.string :nickname,    null: false, index: { unique: true }

      t.string :public_name
      t.text   :biography

      t.references :person, index: { unique: true }

      t.references :contacts_list, null: false, index: { unique: true }
    end

    create_table :person_comments do |t|
      t.timestamps null: false

      t.references :person,  null: false, index: true, foreign_key: true
      t.references :account, null: true,  index: true, foreign_key: true

      t.text :text, null: false
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

      t.references :account, null: false, index: true
      t.references :role,    null: false, index: true

      t.datetime :deleted_at
      t.datetime :expires_at
    end

    create_table :user_omniauths do |t|
      t.timestamps null: false

      t.references :user, foreign_key: true
      t.string :provider,  null: false
      t.string :remote_id, null: false
      t.string :email,     null: false

      t.index %i[remote_id provider], unique: true
    end

    create_table :relationships do |t|
      t.timestamps null: false

      t.references :person,
                   null: false, index: false, foreign_key: true

      t.references :regional_office,
                   null: false, index: true,  foreign_key: true

      t.date :from_date,  null: false, index: true
      t.date :until_date, null: true,  index: false

      t.column :status, :relationship_status, null: false, index: true
      t.column :role,   :relationship_role,   null: true,  index: true

      t.index %i[person_id from_date], unique: true
    end

    add_foreign_key :users,            :accounts
    add_foreign_key :account_roles,    :accounts
    add_foreign_key :account_roles,    :roles
    add_foreign_key :accounts,         :people
    add_foreign_key :regional_offices, :federal_subjects
    add_foreign_key :accounts,         :contacts_lists
    add_foreign_key :people,           :contacts_lists

    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE relationships ADD CONSTRAINT dates CHECK (
            until_date IS NULL OR from_date < until_date
          );

          ALTER TABLE relationships ADD CONSTRAINT role CHECK (
            status = 'member' OR role IS NULL
          );
        SQL
      end
    end

    constraint :accounts, :guest_token, <<~SQL
      guest_token ~ '^[0-9a-f]{32}$'
    SQL

    constraint :accounts, :nickname, <<~SQL
      length(nickname) BETWEEN 3 AND 36
      AND
      nickname ~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$'
    SQL

    constraint :accounts, :public_name, <<~SQL
      public_name IS NULL
      OR
      length(public_name) BETWEEN 3 AND 255
      AND
      public_name !~ '^[[:space:]]*$'
    SQL

    constraint :accounts, :biography, <<~SQL
      biography IS NULL
      OR
      length(biography) BETWEEN 3 AND 10000
      AND
      biography !~ '^[[:space:]]*$'
    SQL

    constraint :federal_subjects, :english_name, <<~SQL
      length(english_name) BETWEEN 1 AND 255
      AND
      english_name !~ '^[[:space:]]{1,}'
      AND
      english_name !~ '[[:space:]]{1,}$'
    SQL

    constraint :federal_subjects, :native_name, <<~SQL
      length(native_name) BETWEEN 1 AND 255
      AND
      native_name !~ '^[[:space:]]{1,}'
      AND
      native_name !~ '[[:space:]]{1,}$'
    SQL

    constraint :federal_subjects, :number, 'number > 0'
  end

private

  def constraint(table, name, check)
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{check})
        SQL
      end

      dir.down do
        execute <<~SQL
          ALTER TABLE #{table} DROP CONSTRAINT #{name}
        SQL
      end
    end
  end
end
