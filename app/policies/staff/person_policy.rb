# frozen_string_literal: true

class Staff::PersonPolicy < ApplicationPolicy
  def index?
    account&.superuser?
  end

  def show?
    account&.superuser?
  end

  def create?
    account&.superuser?
  end

  class Scope < Scope
    def resolve
      return scope.all if account&.superuser?

      scope.none
    end
  end
end
