# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :omniauth_provider, :string
    add_column :users, :omniauth_uid,      :string
  end
end
