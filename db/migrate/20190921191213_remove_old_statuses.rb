# frozen_string_literal: true

class RemoveOldStatuses < ActiveRecord::Migration[6.0]
  include Partynest::Migration

  def change
    remove_constraint :relationships, :regional_secretary_flag, <<~SQL
      regional_secretary_flag IS NULL OR role = 'regional_manager'
    SQL

    remove_constraint :relationships, :federal_secretary_flag, <<~SQL
      federal_secretary_flag IS NULL OR role = 'federal_manager'
    SQL

    remove_constraint :relationships, :role, <<~SQL
      status = 'member' OR role IS NULL
    SQL

    reversible do |dir|
      dir.up do
        remove_index(
          :relationships,
          name: :index_relationships_on_regional_office_id_and_secretary_flag,
        )
      end

      dir.down do
        add_index(
          :relationships,
          %i[regional_office_id regional_secretary_flag],
          name: :index_relationships_on_regional_office_id_and_secretary_flag,
          unique: true,
        )
      end
    end

    reversible do |dir|
      dir.up do
        remove_index :relationships,
                     :federal_secretary_flag
      end

      dir.down do
        add_index :relationships,
                  :federal_secretary_flag,
                  unique: true
      end
    end

    remove_index :relationships, :regional_secretary_flag
    remove_index :relationships, :role
    remove_index :relationships, :status

    remove_column :relationships,
                  :regional_secretary_flag,
                  :relationship_regional_secretary_flag

    remove_column :relationships,
                  :federal_secretary_flag,
                  :relationship_federal_secretary_flag

    remove_column :relationships,
                  :role,
                  :relationship_role

    remove_column :relationships,
                  :status,
                  :relationship_status,
                  null: false

    remove_enum :relationship_status, %i[supporter excluded member]

    remove_enum :relationship_role, %i[
      federal_manager
      federal_supervisor
      regional_manager
      regional_supervisor
    ]

    remove_enum :relationship_regional_secretary_flag, %i[regional_secretary]

    remove_enum :relationship_federal_secretary_flag, %i[federal_secretary]
  end
end
