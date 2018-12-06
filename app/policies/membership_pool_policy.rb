# frozen_string_literal: true

class MembershipPoolPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if context.account&.is_superuser?

      scope.none
    end
  end
end
