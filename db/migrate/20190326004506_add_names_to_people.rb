# frozen_string_literal: true

class AddNamesToPeople < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :people, :first_name,  :string, null: false
    add_column :people, :middle_name, :string
    add_column :people, :last_name,   :string, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
