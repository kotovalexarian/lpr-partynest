# frozen_string_literal: true

class UniqueIndexStatusesOnRelationTransitions < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.down do
        execute <<~SQL
          DROP INDEX
            index_relation_transitions_on_to_status_id_when_from_status_id_is_null
        SQL
      end

      dir.up do
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
  end
end
