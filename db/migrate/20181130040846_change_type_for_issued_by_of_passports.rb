# frozen_string_literal: true

class ChangeTypeForIssuedByOfPassports < ActiveRecord::Migration[5.2]
  def change
    remove_column :passports, :issued_by, :string, null: false
    add_column    :passports, :issued_by, :text,   null: false
  end
end
