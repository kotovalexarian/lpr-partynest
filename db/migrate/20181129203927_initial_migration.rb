# frozen_string_literal: true

class InitialMigration < ActiveRecord::Migration[6.0]
  def change
    func :is_good_text, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN str ~ '^[^[:space:]]+(.*[^[:space:]])?$';
      END;
      $$;
    SQL

    enum :sex, %i[male female]

    enum :relationship_status, %i[supporter excluded member]

    enum :relationship_role, %i[manager supervisor]

    enum :person_comment_origin, %i[
      general_comments
      first_contact_date
      latest_contact_date
      human_readable_id
      past_experience
      aid_at_2014_elections
      aid_at_2015_elections
    ]

    create_table :contacts_lists do |t|
      t.timestamps null: false
    end

    create_table :federal_subjects do |t|
      t.timestamps null: false

      t.string :english_name, null: false, index: { unique: true }
      t.string :native_name,  null: false, index: { unique: true }
      t.string :centre,       null: false, index: false

      t.integer  :number,   null: false, index: { unique: true }
      t.interval :timezone, null: false, index: false
    end

    create_table :regional_offices do |t|
      t.timestamps null: false

      t.references :federal_subject,
                   null: false, index: { unique: true }, foreign_key: true
    end

    create_table :people do |t|
      t.timestamps null: false

      t.string :first_name,     null: false
      t.string :middle_name,    null: true
      t.string :last_name,      null: false
      t.column :sex, :sex,      null: false
      t.date   :date_of_birth,  null: false
      t.string :place_of_birth, null: false

      t.references :contacts_list,
                   null: false, index: { unique: true }, foreign_key: true
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

      t.references :person,          index: true, foreign_key: true
      t.references :federal_subject, index: true, foreign_key: true

      t.string :zip_code

      t.string :town_type
      t.string :town_name
      t.string :settlement_type
      t.string :settlement_name
      t.string :district_type
      t.string :district_name
      t.string :street_type
      t.string :street_name
      t.string :residence_type
      t.string :residence_name
      t.string :building_type
      t.string :building_name
      t.string :apartment_type
      t.string :apartment_name
    end

    create_table :accounts do |t|
      t.timestamps null: false

      t.string :guest_token, null: false, index: { unique: true }
      t.string :nickname,    null: false, index: { unique: true }

      t.string :public_name
      t.text   :biography

      t.references :person, index: { unique: true }, foreign_key: true

      t.references :contacts_list,
                   null: false, index: { unique: true }, foreign_key: true
    end

    create_table :person_comments do |t|
      t.timestamps null: false

      t.references :person,  null: false, index: true, foreign_key: true
      t.references :account, null: true,  index: true, foreign_key: true

      t.text :text, null: false
      t.column :origin, :person_comment_origin
    end

    create_table :users do |t|
      t.timestamps null: false

      t.references :account,
                   null: false, index: { unique: true }, foreign_key: true

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

      t.references :account, null: false, index: true, foreign_key: true
      t.references :role,    null: false, index: true, foreign_key: true

      t.datetime :deleted_at
      t.datetime :expires_at
    end

    create_table :user_omniauths do |t|
      t.timestamps null: false

      t.references :user, index: true, foreign_key: true

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

    constraint :relationships, :dates, <<~SQL
      until_date IS NULL OR from_date < until_date
    SQL

    constraint :relationships, :role, <<~SQL
      status = 'member' OR role IS NULL
    SQL

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
      is_good_text(public_name)
    SQL

    constraint :accounts, :biography, <<~SQL
      biography IS NULL
      OR
      length(biography) BETWEEN 3 AND 10000
      AND
      is_good_text(biography)
    SQL

    constraint :federal_subjects, :english_name, <<~SQL
      length(english_name) BETWEEN 1 AND 255
      AND
      is_good_text(english_name)
    SQL

    constraint :federal_subjects, :native_name, <<~SQL
      length(native_name) BETWEEN 1 AND 255
      AND
      is_good_text(native_name)
    SQL

    constraint :federal_subjects, :centre, <<~SQL
      length(centre) BETWEEN 1 AND 255
      AND
      is_good_text(centre)
    SQL

    constraint :federal_subjects, :number, <<~SQL
      number > 0
    SQL

    constraint :passports, :zip_code, <<~SQL
      zip_code IS NULL
      OR
      length(zip_code) BETWEEN 1 AND 255
      AND
      is_good_text(zip_code)
    SQL

    constraint :passports, :town_type, <<~SQL
      town_type IS NULL
      OR
      length(town_type) BETWEEN 1 AND 255
      AND
      is_good_text(town_type)
    SQL

    constraint :passports, :town_name, <<~SQL
      town_name IS NULL
      OR
      length(town_name) BETWEEN 1 AND 255
      AND
      is_good_text(town_name)
    SQL

    constraint :passports, :settlement_type, <<~SQL
      settlement_type IS NULL
      OR
      length(settlement_type) BETWEEN 1 AND 255
      AND
      is_good_text(settlement_type)
    SQL

    constraint :passports, :settlement_name, <<~SQL
      settlement_name IS NULL
      OR
      length(settlement_name) BETWEEN 1 AND 255
      AND
      is_good_text(settlement_name)
    SQL

    constraint :passports, :district_type, <<~SQL
      district_type IS NULL
      OR
      length(district_type) BETWEEN 1 AND 255
      AND
      is_good_text(district_type)
    SQL

    constraint :passports, :district_name, <<~SQL
      district_name IS NULL
      OR
      length(district_name) BETWEEN 1 AND 255
      AND
      is_good_text(district_name)
    SQL

    constraint :passports, :street_type, <<~SQL
      street_type IS NULL
      OR
      length(street_type) BETWEEN 1 AND 255
      AND
      is_good_text(street_type)
    SQL

    constraint :passports, :street_name, <<~SQL
      street_name IS NULL
      OR
      length(street_name) BETWEEN 1 AND 255
      AND
      is_good_text(street_name)
    SQL

    constraint :passports, :residence_type, <<~SQL
      residence_type IS NULL
      OR
      length(residence_type) BETWEEN 1 AND 255
      AND
      is_good_text(residence_type)
    SQL

    constraint :passports, :residence_name, <<~SQL
      residence_name IS NULL
      OR
      length(residence_name) BETWEEN 1 AND 255
      AND
      is_good_text(residence_name)
    SQL

    constraint :passports, :building_type, <<~SQL
      building_type IS NULL
      OR
      length(building_type) BETWEEN 1 AND 255
      AND
      is_good_text(building_type)
    SQL

    constraint :passports, :building_name, <<~SQL
      building_name IS NULL
      OR
      length(building_name) BETWEEN 1 AND 255
      AND
      is_good_text(building_name)
    SQL

    constraint :passports, :apartment_type, <<~SQL
      apartment_type IS NULL
      OR
      length(apartment_type) BETWEEN 1 AND 255
      AND
      is_good_text(apartment_type)
    SQL

    constraint :passports, :apartment_name, <<~SQL
      apartment_name IS NULL
      OR
      length(apartment_name) BETWEEN 1 AND 255
      AND
      is_good_text(apartment_name)
    SQL
  end

private

  def func(name, sql)
    reversible do |dir|
      dir.up do
        execute "CREATE FUNCTION #{name} #{sql}"
      end

      dir.down do
        execute "DROP FUNCTION #{name}"
      end
    end
  end

  def enum(name, values)
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TYPE #{name}
            AS ENUM (#{values.map { |s| "'#{s}'" }.join(', ')})
        SQL
      end

      dir.down do
        execute "DROP TYPE #{name}"
      end
    end
  end

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
