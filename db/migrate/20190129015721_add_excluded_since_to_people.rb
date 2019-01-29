# frozen_string_literal: true

class AddExcludedSinceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :excluded_since, :date
  end
end
