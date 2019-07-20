# frozen_string_literal: true

class AddConstraintsToImportantTables < ActiveRecord::Migration[6.0]
  def change
    constraint :federal_subjects, :english_name, <<~SQL
      length(english_name) BETWEEN 1 AND 255
      AND
      english_name !~ '^[[:space:]]{1,}'
      AND
      english_name !~ '[[:space:]]{1,}$'
    SQL

    constraint :federal_subjects, :native_name, <<~SQL
      length(native_name) BETWEEN 1 AND 255
      AND
      native_name !~ '^[[:space:]]{1,}'
      AND
      native_name !~ '[[:space:]]{1,}$'
    SQL

    constraint :federal_subjects, :number, 'number > 0'
  end

private

  def constraint(table, name, check)
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{check})
        SQL
      end

      dir.down do
        execute <<~SQL
          ALTER TABLE #{table} DROP CONSTRAINT #{name}
        SQL
      end
    end
  end
end
