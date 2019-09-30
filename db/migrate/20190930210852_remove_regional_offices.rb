# frozen_string_literal: true

class RemoveRegionalOffices < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    remove_reference :relationships,
                     :regional_office,
                     null: false,
                     index: true,
                     foreign_key: true

    drop_constraint :regional_offices, :name, <<~SQL
      is_good_small_text(name)
    SQL

    drop_table :regional_offices do |t|
      t.timestamps null: false

      t.references :federal_subject,
                   null: false,
                   index: { unique: true },
                   foreign_key: true

      t.string :name, null: false, index: { unique: true }
    end
  end
end
