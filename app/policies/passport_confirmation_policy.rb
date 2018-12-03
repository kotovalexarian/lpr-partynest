# frozen_string_literal: true

class PassportConfirmationPolicy < ApplicationPolicy
  def create?
    return false if record.passport.nil?
    return false if record.account != context.account

    policy(record.passport).show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
