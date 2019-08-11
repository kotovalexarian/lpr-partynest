# frozen_string_literal: true

class Staff::Person::PersonCommentPolicy < ApplicationPolicy
  def index?
    account&.superuser?
  end

  def create?
    account&.superuser?
  end

  def permitted_attributes_for_create
    %i[attachment text]
  end

  class Scope < Scope
    def resolve
      return scope.all if account&.superuser?

      scope.none
    end
  end
end
