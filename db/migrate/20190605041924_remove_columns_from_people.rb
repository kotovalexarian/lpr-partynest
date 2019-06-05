# frozen_string_literal: true

class RemoveColumnsFromPeople < ActiveRecord::Migration[6.0]
  def change
    remove_column :people, :supporter_since, :date, index: true, null: false
    remove_column :people, :member_since,    :date, index: true
    remove_column :people, :excluded_since,  :date, index: true
  end
end
