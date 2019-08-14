# frozen_string_literal: true

class Staff::Person::RelationshipPolicy < ApplicationPolicy
  def index?
    account&.superuser?
  end

  class Scope < Scope
    def resolve
      return scope.all if account&.superuser?

      scope.none
    end
  end
end
