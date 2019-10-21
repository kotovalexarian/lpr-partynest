# frozen_string_literal: true

class CreateScripts < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :scripts do |t|
      t.timestamps null: false

      t.string :codename, null: false, index: { unique: true }
      t.string :name,     null: false, index: { unique: true }

      t.text :source_code, null: false
    end

    add_constraint :scripts, :codename, <<~SQL
      is_codename(codename)
    SQL

    add_constraint :scripts, :name, <<~SQL
      is_good_small_text(name)
    SQL
  end
end
