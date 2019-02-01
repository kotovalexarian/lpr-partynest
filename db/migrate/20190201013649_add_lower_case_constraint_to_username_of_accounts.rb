# frozen_string_literal: true

class AddLowerCaseConstraintToUsernameOfAccounts < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        add_constraint :lower_case, 'username = lower(username)'
        add_constraint :min_length, 'length(username) >= 3'
        add_constraint :max_length, 'length(username) <= 36'
      end

      dir.down do
        drop_constraint :lower_case
        drop_constraint :min_length
        drop_constraint :max_length
      end
    end
  end

private

  def add_constraint(name, constraint)
    execute 'ALTER TABLE accounts '                           \
            "ADD CONSTRAINT accounts_username_#{name}_check " \
            "CHECK (#{constraint})"
  end

  def drop_constraint(name)
    execute 'ALTER TABLE accounts '                           \
            "DROP CONSTRAINT accounts_username_#{name}_check"
  end
end
