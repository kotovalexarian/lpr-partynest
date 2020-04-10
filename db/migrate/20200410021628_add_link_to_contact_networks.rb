# frozen_string_literal: true

class AddLinkToContactNetworks < ActiveRecord::Migration[6.0]
  def change
    add_column :contact_networks, :link, :string
  end
end
