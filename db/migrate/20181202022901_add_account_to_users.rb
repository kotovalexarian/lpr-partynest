# frozen_string_literal: true

class AddAccountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users,
                  :account,
                  null:        false, # rubocop:disable Rails/NotNullColumn
                  index:       { unique: true },
                  foreign_key: true
  end
end
