# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.timestamps null: false

      t.references :person,
                   null: false, index: false, foreign_key: true

      t.references :regional_office,
                   null: false, index: true,  foreign_key: true

      t.date    :start_date, null: false, index: true
      t.integer :status,     null: false, index: true

      t.index %i[person_id start_date], unique: true
    end
  end
end
