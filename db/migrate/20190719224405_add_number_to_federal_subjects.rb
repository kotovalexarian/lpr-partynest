# frozen_string_literal: true

class AddNumberToFederalSubjects < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :federal_subjects, :number, :integer, null: false
    add_index  :federal_subjects, :number, unique: true
    # rubocop:enable Rails/NotNullColumn
  end
end
