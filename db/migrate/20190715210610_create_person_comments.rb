# frozen_string_literal: true

class CreatePersonComments < ActiveRecord::Migration[6.0]
  def change
    create_table :person_comments do |t|
      t.timestamps null: false

      t.references :person,  null: false, index: true, foreign_key: true
      t.references :account, null: true,  index: true, foreign_key: true

      t.text :text, null: false
    end
  end
end
