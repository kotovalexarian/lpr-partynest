# frozen_string_literal: true

class CreateRelationTransitions < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    create_table :relation_transitions do |t|
      t.timestamps null: false

      t.references :from_status,
                   null: true,
                   foreign_key: { to_table: :relation_statuses }

      t.references :to_status,
                   null: false,
                   foreign_key: { to_table: :relation_statuses }

      t.string :name, null: false, index: { unique: true }

      t.index %i[from_status_id to_status_id], unique: true
    end

    add_constraint :relation_transitions, :name, <<~SQL
      is_good_small_text(name)
    SQL

    add_constraint :relation_transitions, :statuses, <<~SQL
      from_status_id != to_status_id
    SQL
  end
end
