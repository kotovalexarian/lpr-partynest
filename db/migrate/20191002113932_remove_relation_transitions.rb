# frozen_string_literal: true

class RemoveRelationTransitions < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    remove_constraint :relation_transitions, :name, <<~SQL
      is_good_small_text(name)
    SQL

    remove_constraint :relation_transitions, :statuses, <<~SQL
      from_status_id != to_status_id
    SQL

    reversible do |dir|
      dir.up do
        execute <<~SQL
          DROP INDEX
            index_relation_transitions_on_to_status_id_when_from_status_id_is_null
        SQL
      end

      dir.down do
        execute <<~SQL
          CREATE UNIQUE INDEX
            index_relation_transitions_on_to_status_id_when_from_status_id_is_null
            ON relation_transitions
            USING btree
            (to_status_id)
            WHERE from_status_id IS NULL;
        SQL
      end
    end

    drop_table :relation_transitions do |t|
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
  end
end
