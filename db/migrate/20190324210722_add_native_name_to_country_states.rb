# frozen_string_literal: true

class AddNativeNameToCountryStates < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :country_states, :native_name, :string, null: false
    add_index :country_states, :native_name, unique: true
    # rubocop:enable Rails/NotNullColumn
  end
end
