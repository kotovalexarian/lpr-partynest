# frozen_string_literal: true

class AddShowInPublicToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :show_in_public, :boolean, null: false, default: false
  end
end
