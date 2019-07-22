# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
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
          DROP TYPE relationship_status;
          DROP TYPE relationship_role;
        SQL
      end
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
  end
end
