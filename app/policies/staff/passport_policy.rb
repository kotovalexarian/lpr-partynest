# frozen_string_literal: true

class Staff::PassportPolicy < ApplicationPolicy
  def index?
    account&.is_superuser?
  end

  def show?
    true
  end

  def create?
    true
  end

  def permitted_attributes_for_create
    [
      :images,
      passport_maps_attributes: %i[
        first_name middle_name last_name sex date_of_birth place_of_birth
        series number issued_by unit_code date_of_issue
      ],
    ]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
