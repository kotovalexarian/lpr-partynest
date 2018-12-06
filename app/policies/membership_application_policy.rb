# frozen_string_literal: true

class MembershipApplicationPolicy < ApplicationPolicy
  def show?
    return false if context.guest_account.nil?

    context.guest_account.is_superuser? ||
      record.account == context.guest_account
  end

  def create?
    true
  end

  def permitted_attributes_for_create
    %i[
      first_name last_name middle_name date_of_birth occupation email
      phone_number telegram_username organization_membership comment
      country_state_id
    ]
  end
end
