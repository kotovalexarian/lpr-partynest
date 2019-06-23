# frozen_string_literal: true

class RenameCountryStatesToFederalSubjects < ActiveRecord::Migration[6.0]
  def change
    rename_table :country_states, :federal_subjects
  end
end
