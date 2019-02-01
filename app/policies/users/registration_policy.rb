# frozen_string_literal: true

class Users::RegistrationPolicy < ApplicationPolicy
  def update?
    !account&.user.nil?
  end
end
