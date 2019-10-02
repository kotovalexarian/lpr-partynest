# frozen_string_literal: true

class AddOrgUnitKindToRelationStatuses < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn

    add_reference :relation_statuses,
                  :org_unit_kind,
                  null: false,
                  foreign_key: true

    # rubocop:enable Rails/NotNullColumn
  end
end
