# frozen_string_literal: true

class UniqAccountOnMembershipApps < ActiveRecord::Migration[5.2]
  def change
    remove_index :membership_apps, :account_id
    add_index    :membership_apps, :account_id, unique: true
  end
end
