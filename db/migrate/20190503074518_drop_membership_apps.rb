# frozen_string_literal: true

class DropMembershipApps < ActiveRecord::Migration[6.0]
  def change
    drop_table :membership_apps
  end
end
