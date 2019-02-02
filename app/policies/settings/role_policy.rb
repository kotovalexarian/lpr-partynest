# frozen_string_literal: true

class Settings::RolePolicy < ApplicationPolicy
  def index?
    account && !account.guest?
  end

  class Scope < Scope
    def resolve
      return scope.none if account.nil? || account.guest?

      scope.merge(account.roles)
    end
  end
end
