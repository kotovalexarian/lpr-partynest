# frozen_string_literal: true

class Staff::PassportConfirmationPolicy < ApplicationPolicy
  def create?
    return false if record.passport.nil?
    return false if record.account != context.account

    policy([:staff, record.passport]).show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
