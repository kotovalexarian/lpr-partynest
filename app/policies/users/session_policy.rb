# frozen_string_literal: true

class Users::SessionPolicy < ApplicationPolicy
  def create?
    account&.user.nil?
  end

  def destroy?
    !account.nil?
  end
end
