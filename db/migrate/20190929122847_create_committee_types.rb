# frozen_string_literal: true

class CreateCommitteeTypes < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :committee_types do |t|
      t.timestamps null: false

      t.string :codename, null: false, index: { unique: true }
      t.string :name,     null: false, index: { unique: true }

      t.boolean :regional, null: false
    end

    constraint :committee_types, :codename, <<~SQL
      is_codename(codename)
    SQL

    constraint :committee_types, :name, <<~SQL
      is_good_small_text(name)
    SQL
  end
end
