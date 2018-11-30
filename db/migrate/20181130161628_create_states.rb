# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.timestamps null: false
      t.string :name, null: false

      t.index :name, unique: true
    end
  end
end
