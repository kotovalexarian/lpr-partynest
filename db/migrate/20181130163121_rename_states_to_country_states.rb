# frozen_string_literal: true

class RenameStatesToCountryStates < ActiveRecord::Migration[5.2]
  def change
    rename_table :states, :country_states
  end
end
