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

      t.date :supporter_since, index: true, null: false
      t.date :member_since,    index: true
      t.date :excluded_since,  index: true
    end
  end
end
