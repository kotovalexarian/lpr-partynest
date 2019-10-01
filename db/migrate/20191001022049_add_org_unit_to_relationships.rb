# frozen_string_literal: true

class AddOrgUnitToRelationships < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :relationships, :org_unit, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
