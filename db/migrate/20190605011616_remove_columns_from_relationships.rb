# frozen_string_literal: true

class RemoveColumnsFromRelationships < ActiveRecord::Migration[6.0]
  def change
    remove_column :relationships, :supporter_since, :date, index: true,
                                                           null: false
    remove_column :relationships, :member_since,    :date, index: true
    remove_column :relationships, :excluded_since,  :date, index: true
  end
end
