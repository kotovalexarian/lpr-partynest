# frozen_string_literal: true

class Staff::Person::PersonCommentPolicy < ApplicationPolicy
  def index?
    return false if restricted?

    account&.superuser?
  end

  def create?
    return false if restricted?

    account&.superuser?
  end

  def permitted_attributes_for_create
    return [] if restricted?

    %i[attachment text]
  end

  class Scope < Scope
    def resolve
      return scope.none if restricted?

      return scope.all if account&.superuser?

      scope.none
    end
  end
end
