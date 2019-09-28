# frozen_string_literal: true

class AddStatusToRelationships < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :relationships, :status, null: false
    add_foreign_key :relationships, :relation_statuses, column: :status_id
    # rubocop:enable Rails/NotNullColumn
  end
end
