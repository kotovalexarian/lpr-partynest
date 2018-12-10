# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.timestamps null: false
    end
  end
end
