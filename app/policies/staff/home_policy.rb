# frozen_string_literal: true

class Staff::HomePolicy < ApplicationPolicy
  def show?
    account&.is_superuser?
  end
end
