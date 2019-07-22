# frozen_string_literal: true

class AddPersonalDataToPeople < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute "CREATE TYPE sex AS ENUM ('male', 'female')"
      end

      dir.down do
        execute 'DROP TYPE sex'
      end
    end

    # rubocop:disable Rails/NotNullColumn
    add_column :people, :sex,            :sex,    null: false
    add_column :people, :date_of_birth,  :date,   null: false
    add_column :people, :place_of_birth, :string, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
