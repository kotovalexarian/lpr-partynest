# frozen_string_literal: true

class CreateOrgUnits < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :org_units do |t|
      t.timestamps null: false

      t.string :short_name, null: false, index: { unique: true }
      t.string :name,       null: false, index: { unique: true }

      t.references :kind,
                   null: false,
                   index: true,
                   foreign_key: { to_table: :org_unit_kinds }

      t.references :parent,
                   null: true,
                   index: true,
                   foreign_key: { to_table: :org_units }
    end

    add_constraint :org_units, :short_name, <<~SQL
      is_good_small_text(short_name)
    SQL

    add_constraint :org_units, :name, <<~SQL
      is_good_small_text(name)
    SQL
  end
end
