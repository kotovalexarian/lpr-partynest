# frozen_string_literal: true

class CreateRegionalOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :regional_offices do |t|
      t.timestamps null: false

      t.references :country_state,
                   null: false,
                   index: { unique: true },
                   foreign_key: true
    end
  end
end
