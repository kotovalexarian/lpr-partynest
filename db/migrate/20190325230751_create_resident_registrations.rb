# frozen_string_literal: true

class CreateResidentRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :resident_registrations do |t|
      t.timestamps null: false

      t.references :person, index: true, foreign_key: true
    end
  end
end
