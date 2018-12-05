# frozen_string_literal: true

class MembershipApplicationPolicy < ApplicationPolicy
  def show?
    record.account == context.account
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
