# frozen_string_literal: true

class CreateMembershipApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_applications do |t|
      t.timestamps null: false

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.date :date_of_birth, null: false
    end
  end
end
