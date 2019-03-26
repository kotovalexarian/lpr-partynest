# frozen_string_literal: true

class RenamePeopleNames < ActiveRecord::Migration[6.0]
  def change
    rename_column :passport_maps, :given_name, :first_name
    rename_column :passport_maps, :patronymic, :middle_name
    rename_column :passport_maps, :surname,    :last_name
  end
end
