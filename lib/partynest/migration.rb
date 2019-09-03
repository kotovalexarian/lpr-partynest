# frozen_string_literal: true

module Partynest
  module Migration
    def func(name, sql)
      reversible do |dir|
        dir.up do
          execute "CREATE FUNCTION #{name} #{sql}"
        end

        dir.down do
          execute "DROP FUNCTION #{name}"
        end
      end
    end

    def enum(name, values)
      reversible do |dir|
        dir.up do
          execute <<~SQL
            CREATE TYPE #{name}
              AS ENUM (#{values.map { |s| "'#{s}'" }.join(', ')})
          SQL
        end

        dir.down do
          execute "DROP TYPE #{name}"
        end
      end
    end

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
end
