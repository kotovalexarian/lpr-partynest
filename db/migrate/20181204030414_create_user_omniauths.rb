# frozen_string_literal: true

class CreateUserOmniauths < ActiveRecord::Migration[5.2]
  def change
    create_table :user_omniauths do |t|
      t.timestamps null: false

      t.references :user, foreign_key: true
      t.string :provider,  null: false
      t.string :remote_id, null: false
      t.string :email,     null: false

      t.index %i[remote_id provider], unique: true
    end
  end
end
