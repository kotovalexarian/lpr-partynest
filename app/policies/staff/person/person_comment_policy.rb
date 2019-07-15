# frozen_string_literal: true

class Staff::Person::PersonCommentPolicy < ApplicationPolicy
  def index?
    account&.is_superuser?
  end

  def create?
    account&.is_superuser?
  end

  def permitted_attributes_for_create
    %i[text]
  end

  class Scope < Scope
    def resolve
      return scope.all if account&.is_superuser?

      scope.none
    end
  end
end
