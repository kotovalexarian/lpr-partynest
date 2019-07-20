# frozen_string_literal: true

class AddTimezoneToFederalSubjects < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :federal_subjects, :timezone, :interval, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
