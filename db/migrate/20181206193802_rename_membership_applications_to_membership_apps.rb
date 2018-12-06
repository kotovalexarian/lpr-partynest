# frozen_string_literal: true

class RenameMembershipApplicationsToMembershipApps < ActiveRecord::Migration[5.2] # rubocop:disable Metrics/LineLength
  def change
    rename_table :membership_applications, :membership_apps
  end
end
