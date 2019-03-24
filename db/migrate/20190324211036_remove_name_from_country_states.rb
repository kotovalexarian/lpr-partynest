# frozen_string_literal: true

class RemoveNameFromCountryStates < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    remove_column :country_states, :name
    # rubocop:enable Rails/ReversibleMigration
  end
end
