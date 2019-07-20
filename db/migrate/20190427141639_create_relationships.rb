# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.timestamps null: false

      t.references :person,          null: false, index: false
      t.references :regional_office, null: false, index: true, foreign_key: true

      t.integer :number, null: false

      t.index %i[person_id number], unique: true
      t.foreign_key :people
    end

    # rubocop:disable Rails/NotNullColumn
    add_column :relationships, :active_since, :date, null: false
    # rubocop:enable Rails/NotNullColumn
    add_index  :relationships, :active_since
  end
end
