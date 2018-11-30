# frozen_string_literal: true

class PassportPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  def permitted_attributes_for_create
    %i[
      surname given_name patronymic sex date_of_birth place_of_birth series
      number issued_by unit_code date_of_issue
    ]
  end

  def permitted_attributes_for_update
    %i[image]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
