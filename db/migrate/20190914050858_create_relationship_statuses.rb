# frozen_string_literal: true

class CreateRelationshipStatuses < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :relationship_statuses do |t|
      t.timestamps null: false

      t.string :codename, null: false, index: { unique: true }
      t.string :name,     null: false, index: { unique: true }
    end

    constraint :relationship_statuses, :codename, <<~SQL
      is_codename(codename)
    SQL
  end
end
