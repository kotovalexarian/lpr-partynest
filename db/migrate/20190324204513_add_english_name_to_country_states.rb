# frozen_string_literal: true

class AddEnglishNameToCountryStates < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :country_states, :english_name, :string, null: false
    add_index :country_states, :english_name, unique: true
    # rubocop:enable Rails/NotNullColumn
  end
end
