# frozen_string_literal: true

class MembershipAppPolicy < ApplicationPolicy
  def show?
    return false if account.nil?

    record.account == account
  end

  def create?
    account.nil? || account.own_membership_app.nil?
  end

  def permitted_attributes_for_create
    %i[
      first_name last_name middle_name date_of_birth occupation email
      phone_number telegram_username organization_membership comment
      country_state_id
    ]
  end
end
