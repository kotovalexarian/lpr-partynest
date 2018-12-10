# frozen_string_literal: true

class AddPersonToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :person, index: { unique: true }, foreign_key: true
  end
end
