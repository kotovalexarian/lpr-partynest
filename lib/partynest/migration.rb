# frozen_string_literal: true

module Partynest
  module Migration
    def func(name, sql)
      reversible do |dir|
        dir.up { execute "CREATE FUNCTION #{name} #{sql}" }

        dir.down { execute "DROP FUNCTION #{name}" }
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

        dir.down { execute "DROP TYPE #{name}" }
      end
    end

    def constraint(table, name, check)
      reversible do |dir|
        dir.up do
          execute <<~SQL
            ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{check})
          SQL
        end

        dir.down { execute "ALTER TABLE #{table} DROP CONSTRAINT #{name}" }
      end
    end
  end
end
