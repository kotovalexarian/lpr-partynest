# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.timestamps null: false

      t.references :person,
                   null: false, index: false, foreign_key: true

      t.references :regional_office,
                   null: false, index: true,  foreign_key: true

      t.date    :from_date,  null: false, index: true
      t.date    :until_date, null: true,  index: false
      t.integer :status,     null: false, index: true
      t.integer :role,       null: true,  index: true

      t.index %i[person_id from_date], unique: true
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE relationships ADD CONSTRAINT dates CHECK (
            until_date IS NULL OR from_date < until_date
          );

          ALTER TABLE relationships ADD CONSTRAINT role CHECK (
            status = 2 /* member */ OR role IS NULL
          );
        SQL
      end
    end
  end
end
