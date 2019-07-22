# frozen_string_literal: true

class RemoveNameFromCountryStates < ActiveRecord::Migration[6.0]
  def change
    remove_column :country_states, :name, :string, index: { unique: true }
  end
end
