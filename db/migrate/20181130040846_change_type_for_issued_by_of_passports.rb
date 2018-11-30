# frozen_string_literal: true

class ChangeTypeForIssuedByOfPassports < ActiveRecord::Migration[5.2]
  def change
    change_table :passports, bulk: true do |t|
      t.remove :issued_by # rubocop:disable Rails/ReversibleMigration
      t.text :issued_by, null: false
    end
  end
end
