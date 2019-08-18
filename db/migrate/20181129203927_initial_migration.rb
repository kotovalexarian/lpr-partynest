# frozen_string_literal: true

class InitialMigration < ActiveRecord::Migration[6.0]
  def change
    change_types
    change_functions
    change_tables
    change_sequences
    change_constraints
    change_triggers
  end

private

  def change_types
    enum :sex, %i[male female]

    enum :relationship_status, %i[supporter excluded member]

    enum :relationship_role, %i[
      federal_manager
      federal_supervisor
      regional_manager
      regional_supervisor
    ]

    enum :relationship_federal_secretary_flag, %i[federal_secretary]

    enum :relationship_regional_secretary_flag, %i[regional_secretary]

    enum :person_comment_origin, %i[
      general_comments
      first_contact_date
      latest_contact_date
      human_readable_id
      past_experience
      aid_at_2014_elections
      aid_at_2015_elections
    ]
  end

  def change_functions
    func :is_guest_token, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN str ~ '^[0-9a-f]{32}$';
      END;
      $$;
    SQL

    func :is_nickname, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN length(str) BETWEEN 3 AND 36
          AND str ~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$';
      END;
      $$;
    SQL

    func :is_codename, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN is_nickname(str);
      END;
      $$;
    SQL

    func :is_good_text, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN str ~ '^[^[:space:]]+(.*[^[:space:]])?$';
      END;
      $$;
    SQL

    func :is_good_limited_text, <<~SQL
      (str text, max_length integer)
        RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN LENGTH(str) BETWEEN 1 AND max_length AND is_good_text(str);
      END;
      $$;
    SQL

    func :is_good_small_text, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN is_good_limited_text(str, 255);
      END;
      $$;
    SQL

    func :is_good_big_text, <<~SQL
      (str text) RETURNS boolean IMMUTABLE LANGUAGE plpgsql AS
      $$
      BEGIN
        RETURN is_good_limited_text(str, 10000);
      END;
      $$;
    SQL

    func :ensure_superuser_has_related_user, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        user record;
      BEGIN
        IF NOT NEW.superuser THEN
          RETURN NEW;
        END IF;

        SELECT * FROM users INTO user WHERE users.account_id = NEW.id;

        IF user IS NULL THEN
          RAISE EXCEPTION 'does not have related user';
        END IF;

        RETURN NEW;
      END;
      $$
    SQL

    func :ensure_contact_list_id_remains_unchanged, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      BEGIN
        IF NEW.contact_list_id IS DISTINCT FROM OLD.contact_list_id THEN
          RAISE EXCEPTION 'can not change column "contact_list_id"';
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL

    func :ensure_contact_list_id_matches_related_person, <<~SQL
      () RETURNS trigger LANGUAGE plpgsql AS
      $$
      DECLARE
        person record;
      BEGIN
        IF NEW.person_id IS NULL THEN
          RETURN NEW;
        END IF;

        SELECT * FROM people INTO person WHERE people.id = NEW.person_id;

        IF person IS NULL THEN
          RETURN NEW;
        END IF;

        IF NEW.contact_list_id IS DISTINCT FROM person.contact_list_id THEN
          RAISE EXCEPTION
            'column "contact_list_id" does not match related person';
        END IF;

        RETURN NEW;
      END;
      $$;
    SQL
  end

  def change_tables
    create_table :contact_networks do |t|
      t.timestamps null: false

      t.string :codename, null: false, index: { unique: true }
      t.string :name,     null: false, index: { unique: true }
    end

    create_table :contact_lists do |t|
      t.timestamps null: false
    end

    create_table :contacts do |t|
      t.timestamps null: false

      t.references :contact_list,    null: false, index: true, foreign_key: true
      t.references :contact_network, null: false, index: true, foreign_key: true

      t.string :value, null: false
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

      t.string :name, null: false, index: { unique: true }
    end

    create_table :people do |t|
      t.timestamps null: false

      t.string :first_name,     null: false
      t.string :middle_name,    null: true
      t.string :last_name,      null: false
      t.column :sex, :sex,      null: true
      t.date   :date_of_birth,  null: true
      t.string :place_of_birth, null: true

      t.references :contact_list,
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

      t.boolean :superuser, null: false, default: false

      t.references :person, index: { unique: true }, foreign_key: true

      t.references :contact_list,
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

      t.references :person,            null: false,
                                       index: false,
                                       foreign_key: true

      t.references :regional_office,   null: false,
                                       index: true,
                                       foreign_key: true

      t.references :initiator_account, null: true,
                                       index: true,
                                       foreign_key: { to_table: :accounts }

      t.date :from_date, null: false, index: true

      t.column :status, :relationship_status, null: false, index: true
      t.column :role,   :relationship_role,   null: true,  index: true

      t.column :federal_secretary_flag,
               :relationship_federal_secretary_flag,
               null: true,
               index: { unique: true }

      t.column :regional_secretary_flag,
               :relationship_regional_secretary_flag,
               null: true,
               index: true

      t.index %i[person_id from_date], unique: true

      t.index(
        %i[regional_office_id regional_secretary_flag],
        name: :index_relationships_on_regional_office_id_and_secretary_flag,
        unique: true,
      )
    end
  end

  def change_sequences
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER SEQUENCE contact_networks_id_seq RESTART WITH 100;
          ALTER SEQUENCE federal_subjects_id_seq RESTART WITH 100;
          ALTER SEQUENCE contacts_id_seq         RESTART WITH 4000;
          ALTER SEQUENCE people_id_seq           RESTART WITH 3000;
        SQL
      end
    end
  end

  def change_constraints
    constraint :regional_offices, :name, <<~SQL
      is_good_small_text(name)
    SQL

    constraint :contacts, :value, <<~SQL
      is_good_small_text(value)
    SQL

    constraint :contact_networks, :codename, <<~SQL
      is_codename(codename)
    SQL

    constraint :contact_networks, :name, <<~SQL
      is_good_small_text(name)
    SQL

    constraint :relationships, :role, <<~SQL
      status = 'member' OR role IS NULL
    SQL

    constraint :relationships, :federal_secretary_flag, <<~SQL
      federal_secretary_flag IS NULL OR role = 'federal_manager'
    SQL

    constraint :relationships, :regional_secretary_flag, <<~SQL
      regional_secretary_flag IS NULL OR role = 'regional_manager'
    SQL

    constraint :accounts, :guest_token, <<~SQL
      is_guest_token(guest_token)
    SQL

    constraint :accounts, :nickname, <<~SQL
      is_nickname(nickname)
    SQL

    constraint :accounts, :public_name, <<~SQL
      public_name IS NULL OR is_good_small_text(public_name)
    SQL

    constraint :accounts, :biography, <<~SQL
      biography IS NULL OR is_good_big_text(biography)
    SQL

    constraint :federal_subjects, :english_name, <<~SQL
      is_good_small_text(english_name)
    SQL

    constraint :federal_subjects, :native_name, <<~SQL
      is_good_small_text(native_name)
    SQL

    constraint :federal_subjects, :centre, <<~SQL
      is_good_small_text(centre)
    SQL

    constraint :federal_subjects, :number, <<~SQL
      number > 0
    SQL

    constraint :passports, :zip_code, <<~SQL
      zip_code IS NULL OR is_good_small_text(zip_code)
    SQL

    constraint :passports, :town_type, <<~SQL
      town_type IS NULL OR is_good_small_text(town_type)
    SQL

    constraint :passports, :town_name, <<~SQL
      town_name IS NULL OR is_good_small_text(town_name)
    SQL

    constraint :passports, :settlement_type, <<~SQL
      settlement_type IS NULL OR is_good_small_text(settlement_type)
    SQL

    constraint :passports, :settlement_name, <<~SQL
      settlement_name IS NULL OR is_good_small_text(settlement_name)
    SQL

    constraint :passports, :district_type, <<~SQL
      district_type IS NULL OR is_good_small_text(district_type)
    SQL

    constraint :passports, :district_name, <<~SQL
      district_name IS NULL OR is_good_small_text(district_name)
    SQL

    constraint :passports, :street_type, <<~SQL
      street_type IS NULL OR is_good_small_text(street_type)
    SQL

    constraint :passports, :street_name, <<~SQL
      street_name IS NULL OR is_good_small_text(street_name)
    SQL

    constraint :passports, :residence_type, <<~SQL
      residence_type IS NULL OR is_good_small_text(residence_type)
    SQL

    constraint :passports, :residence_name, <<~SQL
      residence_name IS NULL OR is_good_small_text(residence_name)
    SQL

    constraint :passports, :building_type, <<~SQL
      building_type IS NULL OR is_good_small_text(building_type)
    SQL

    constraint :passports, :building_name, <<~SQL
      building_name IS NULL OR is_good_small_text(building_name)
    SQL

    constraint :passports, :apartment_type, <<~SQL
      apartment_type IS NULL OR is_good_small_text(apartment_type)
    SQL

    constraint :passports, :apartment_name, <<~SQL
      apartment_name IS NULL OR is_good_small_text(apartment_name)
    SQL
  end

  def change_triggers
    reversible do |dir|
      dir.down do
        execute 'DROP TRIGGER ensure_superuser_has_related_user ON accounts;'
      end

      dir.up do
        execute <<~SQL
          CREATE TRIGGER ensure_superuser_has_related_user
            BEFORE INSERT OR UPDATE
            ON accounts
            FOR EACH ROW
            EXECUTE PROCEDURE ensure_superuser_has_related_user();
        SQL
      end
    end

    reversible do |dir|
      dir.down do
        execute <<~SQL
          DROP TRIGGER ensure_contact_list_id_remains_unchanged
            ON people;
        SQL
      end

      dir.up do
        execute <<~SQL
          CREATE TRIGGER ensure_contact_list_id_remains_unchanged
            BEFORE UPDATE OF contact_list_id
            ON people
            FOR EACH ROW
            EXECUTE PROCEDURE ensure_contact_list_id_remains_unchanged();
        SQL
      end
    end

    reversible do |dir|
      dir.down do
        execute <<~SQL
          DROP TRIGGER ensure_contact_list_id_matches_related_person
            ON accounts;
        SQL
      end

      dir.up do
        execute <<~SQL
          CREATE TRIGGER ensure_contact_list_id_matches_related_person
            BEFORE INSERT OR UPDATE OF person_id, contact_list_id
            ON accounts
            FOR EACH ROW
            EXECUTE PROCEDURE ensure_contact_list_id_matches_related_person();
        SQL
      end
    end
  end

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
