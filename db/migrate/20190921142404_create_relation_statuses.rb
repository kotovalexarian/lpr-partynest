# frozen_string_literal: true

class CreateRelationStatuses < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :relation_statuses do |t|
      t.timestamps null: false

      t.string :codename, null: false, index: { unique: true }
      t.string :name,     null: false, index: { unique: true }
    end

    constraint :relation_statuses, :codename, <<~SQL
      is_codename(codename)
    SQL

    constraint :relation_statuses, :name, <<~SQL
      is_good_small_text(name)
    SQL
  end
end
