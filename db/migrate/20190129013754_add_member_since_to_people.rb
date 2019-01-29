# frozen_string_literal: true

class AddMemberSinceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :member_since, :date
  end
end
