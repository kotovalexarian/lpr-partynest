# frozen_string_literal: true

class AddPersonalDataToPeople < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :people, :sex,            :integer, null: false
    add_column :people, :date_of_birth,  :date,    null: false
    add_column :people, :place_of_birth, :string,  null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
