# frozen_string_literal: true

class Staff::HomePolicy < ApplicationPolicy
  def show?
    return false if restricted?

    account&.superuser?
  end
end
