# frozen_string_literal: true

class CreateContactsLists < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts_lists do |t|
      t.timestamps null: false
    end

    # rubocop:disable Rails/NotNullColumn

    add_reference :accounts, :contacts_list,
                  null: false, index: { unique: true }, foreign_key: true

    add_reference :people, :contacts_list,
                  null: false, index: { unique: true }, foreign_key: true

    # rubocop:enable Rails/NotNullColumn
  end
end
