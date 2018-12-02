# frozen_string_literal: true

class AddAccountToMembershipApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :membership_applications, :account,
                  null:        false, # rubocop:disable Rails/NotNullColumn
                  foreign_key: true
  end
end
