# frozen_string_literal: true

class CreatePassports < ActiveRecord::Migration[5.2]
  def change
    create_table :passports do |t|
      t.timestamps null: false

      t.string  :surname,        null: false
      t.string  :given_name,     null: false
      t.string  :patronymic
      t.integer :sex,            null: false
      t.date    :date_of_birth,  null: false
      t.string  :place_of_birth, null: false
      t.integer :series,         null: false
      t.integer :number,         null: false
      t.string  :issued_by,      null: false
      t.string  :unit_code,      null: false
      t.date    :date_of_issue,  null: false
    end
  end
end
