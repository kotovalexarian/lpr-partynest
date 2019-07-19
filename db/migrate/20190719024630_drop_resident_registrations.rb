# frozen_string_literal: true

class DropResidentRegistrations < ActiveRecord::Migration[6.0]
  def change
    drop_table :resident_registrations
  end
end
