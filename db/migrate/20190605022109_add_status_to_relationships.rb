# frozen_string_literal: true

class AddStatusToRelationships < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :relationships, :status, :integer, null: false
    # rubocop:enable Rails/NotNullColumn
    add_index  :relationships, :status
  end
end
