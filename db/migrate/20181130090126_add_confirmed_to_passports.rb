# frozen_string_literal: true

class AddConfirmedToPassports < ActiveRecord::Migration[5.2]
  def change
    add_column :passports, :confirmed, :boolean, null: false, default: false
  end
end
