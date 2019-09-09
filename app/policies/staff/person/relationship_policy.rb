# frozen_string_literal: true

class Staff::Person::RelationshipPolicy < ApplicationPolicy
  def index?
    return false if restricted?

    account&.superuser?
  end

  class Scope < Scope
    def resolve
      return scope.none if restricted?

      return scope.all if account&.superuser?

      scope.none
    end
  end
end
