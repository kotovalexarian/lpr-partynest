# frozen_string_literal: true

class FixRelationshipsIndexOnFromDate < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        remove_index :relationships, %i[person_id from_date]
      end

      dir.down do
        add_index :relationships, %i[person_id from_date], unique: true
      end
    end

    add_index :relationships, %i[person_id org_unit_id from_date], unique: true
  end
end
