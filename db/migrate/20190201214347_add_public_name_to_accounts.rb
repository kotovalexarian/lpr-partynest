# frozen_string_literal: true

class AddPublicNameToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :public_name, :string
  end
end
