# frozen_string_literal: true

class Users::RegistrationPolicy < ApplicationPolicy
  def create?
    account&.user.nil?
  end

  def update?
    !account&.user.nil?
  end
end
