# frozen_string_literal: true

class Staff::Person::AccountConnectionLinkPolicy < ApplicationPolicy
  def show?
    return false if restricted?

    record.person.account.nil? && account&.superuser?
  end

  def create?
    return false if restricted?

    record.person.account.nil? && account&.superuser?
  end
end
