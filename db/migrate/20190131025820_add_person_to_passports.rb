# frozen_string_literal: true

class AddPersonToPassports < ActiveRecord::Migration[6.0]
  def change
    add_reference :passports, :person, foreign_key: true
  end
end
