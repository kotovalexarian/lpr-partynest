# frozen_string_literal: true

class AddActiveSinceToRelationships < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :relationships, :active_since, :date, null: false
    # rubocop:enable Rails/NotNullColumn
    add_index  :relationships, :active_since
  end
end
