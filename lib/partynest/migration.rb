# frozen_string_literal: true

module Partynest
  module Migration
    def func(name, sql)
      reversible do |dir|
        dir.up   { func_creation(name, sql).call }
        dir.down { func_deletion(name).call      }
      end
    end

    def enum(name, values)
      reversible do |dir|
        dir.up   { enum_creation(name, values).call }
        dir.down { enum_deletion(name).call         }
      end
    end

    def constraint(table, name, check)
      reversible do |dir|
        dir.up   { constraint_creation(table, name, check).call }
        dir.down { constraint_deletion(table, name).call        }
      end
    end

  private

    def func_creation(name, sql)
      lambda do
        execute "CREATE FUNCTION #{name} #{sql}"
      end
    end

    def enum_creation(name, values)
      lambda do
        execute <<~SQL
          CREATE TYPE #{name}
            AS ENUM (#{values.map { |s| "'#{s}'" }.join(', ')})
        SQL
      end
    end

    def constraint_creation(table, name, check)
      lambda do
        execute <<~SQL
          ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{check})
        SQL
      end
    end

    def func_deletion(name)
      lambda do
        execute "DROP FUNCTION #{name}"
      end
    end

    def enum_deletion(name)
      lambda do
        execute "DROP TYPE #{name}"
      end
    end

    def constraint_deletion(table, name)
      lambda do
        execute "ALTER TABLE #{table} DROP CONSTRAINT #{name}"
      end
    end
  end
end
