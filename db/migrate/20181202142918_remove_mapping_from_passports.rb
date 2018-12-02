# frozen_string_literal: true

class RemoveMappingFromPassports < ActiveRecord::Migration[5.2]
  def change
    remove_column :passports, :surname,        :string,  null: false
    remove_column :passports, :given_name,     :string,  null: false
    remove_column :passports, :patronymic,     :string
    remove_column :passports, :sex,            :integer, null: false
    remove_column :passports, :date_of_birth,  :date,    null: false
    remove_column :passports, :place_of_birth, :string,  null: false
    remove_column :passports, :series,         :integer, null: false
    remove_column :passports, :number,         :integer, null: false
    remove_column :passports, :issued_by,      :text,    null: false
    remove_column :passports, :unit_code,      :string,  null: false
    remove_column :passports, :date_of_issue,  :date,    null: false
  end
end
