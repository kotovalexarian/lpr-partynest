# frozen_string_literal: true

class Staff::Person::AccountConnectionLinkPolicy < ApplicationPolicy
  def show?
    return false if restricted?

    record.person.account.nil? && account&.superuser?
  end

  def create?
    return false if restricted?

    show?
  end

  def destroy?
    return false if restricted?

    create? && !record.person.account_connection_token.nil?
  end
end
