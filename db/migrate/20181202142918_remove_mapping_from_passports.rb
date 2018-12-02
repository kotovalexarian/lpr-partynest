# frozen_string_literal: true

class RemoveMappingFromPassports < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/ReversibleMigration
    change_table :passports, bulk: true do |t|
      t.remove :surname
      t.remove :given_name
      t.remove :patronymic
      t.remove :sex
      t.remove :date_of_birth
      t.remove :place_of_birth
      t.remove :series
      t.remove :number
      t.remove :issued_by
      t.remove :unit_code
      t.remove :date_of_issue
    end
    # rubocop:enable Rails/ReversibleMigration
  end
end
