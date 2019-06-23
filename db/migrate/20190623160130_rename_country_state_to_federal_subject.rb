# frozen_string_literal: true

class RenameCountryStateToFederalSubject < ActiveRecord::Migration[6.0]
  def change
    rename_column :regional_offices, :country_state_id, :federal_subject_id
  end
end
