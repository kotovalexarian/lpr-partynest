# frozen_string_literal: true

class CreatePassportMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :passport_maps do |t|
      t.timestamps null: false

      t.references :passport, null: false,
                              index: { unique: true }, foreign_key: true

      t.string  :surname,        null: false
      t.string  :given_name,     null: false
      t.string  :patronymic
      t.integer :sex,            null: false
      t.date    :date_of_birth,  null: false
      t.string  :place_of_birth, null: false
      t.integer :series,         null: false
      t.integer :number,         null: false
      t.text    :issued_by,      null: false
      t.string  :unit_code,      null: false
      t.date    :date_of_issue,  null: false
    end
  end
end
