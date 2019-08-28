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

  def permitted_attributes_for_create
    %i[last_name first_name middle_name sex date_of_birth place_of_birth photo]
  end

  class Scope < Scope
    def resolve
      return scope.all if account&.superuser?

      scope.none
    end
  end
end
