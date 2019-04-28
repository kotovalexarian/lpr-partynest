# frozen_string_literal: true

class NonUniquePassportForPassportMaps < ActiveRecord::Migration[5.2]
  def change
    remove_reference :passport_maps, :passport,
                     null: false,
                     index: { unique: true },
                     foreign_key: true

    add_reference :passport_maps, :passport,
                  null: false, # rubocop:disable Rails/NotNullColumn
                  foreign_key: true
  end
end
