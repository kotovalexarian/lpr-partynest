# frozen_string_literal: true

class TurnPassportMapsIntoPassports < ActiveRecord::Migration[6.0]
  def change
    drop_table :passport_maps
    drop_table :passports

    create_table :passports do |t|
      t.timestamps null: false

      t.string  :last_name,      null: false
      t.string  :first_name,     null: false
      t.string  :middle_name
      t.integer :sex,            null: false
      t.date    :date_of_birth,  null: false
      t.string  :place_of_birth, null: false
      t.integer :series,         null: false
      t.integer :number,         null: false
      t.text    :issued_by,      null: false
      t.string  :unit_code,      null: false
      t.date    :date_of_issue,  null: false

      t.references :person, index: true, foreign_key: true
    end
  end
end
