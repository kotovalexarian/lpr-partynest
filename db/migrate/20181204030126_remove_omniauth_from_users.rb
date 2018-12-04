# frozen_string_literal: true

class RemoveOmniauthFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :omniauth_provider, :string
    remove_column :users, :omniauth_uid,      :string
  end
end
