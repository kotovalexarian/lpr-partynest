# frozen_string_literal: true

class AddConstraintsToAccounts < ActiveRecord::Migration[6.0]
  def change
    constraint :accounts, :guest_token, <<~SQL
      guest_token ~ '^[0-9a-f]{32}$'
    SQL

    constraint :accounts, :nickname, <<~SQL
      length(nickname) BETWEEN 3 AND 36
      AND
      nickname ~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$'
    SQL

    constraint :accounts, :public_name, <<~SQL
      public_name IS NULL
      OR
      length(public_name) BETWEEN 3 AND 255
      AND
      public_name !~ '^[[:space:]]*$'
    SQL

    constraint :accounts, :biography, <<~SQL
      biography IS NULL
      OR
      length(biography) BETWEEN 3 AND 10000
      AND
      biography !~ '^[[:space:]]*$'
    SQL
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
