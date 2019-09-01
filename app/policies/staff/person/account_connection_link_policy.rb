# frozen_string_literal: true

class Staff::Person::AccountConnectionLinkPolicy < ApplicationPolicy
  def show?
    account&.superuser?
  end

  def create?
    record.person.account.nil? && account&.superuser?
  end
end
