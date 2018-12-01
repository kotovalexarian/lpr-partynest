# frozen_string_literal: true

class AddCountryStateToMembershipApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :membership_applications, :country_state, foreign_key: true
  end
end
