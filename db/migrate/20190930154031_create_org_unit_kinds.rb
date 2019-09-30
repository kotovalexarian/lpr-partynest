# frozen_string_literal: true

class CreateOrgUnitKinds < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :org_unit_kinds do |t|
      t.timestamps null: false

      t.string :codename,   null: false, index: { unique: true }
      t.string :short_name, null: false, index: { unique: true }
      t.string :name,       null: false, index: { unique: true }

      t.references :parent_kind, null: true, index: true
      t.foreign_key :org_unit_kinds, column: :parent_kind_id
    end

    add_constraint :org_unit_kinds, :codename, <<~SQL
      is_codename(codename)
    SQL

    add_constraint :org_unit_kinds, :short_name, <<~SQL
      is_good_small_text(short_name)
    SQL

    add_constraint :org_unit_kinds, :name, <<~SQL
      is_good_small_text(name)
    SQL
  end
end
