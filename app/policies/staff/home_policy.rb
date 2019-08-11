# frozen_string_literal: true

class Staff::HomePolicy < ApplicationPolicy
  def show?
    account&.superuser?
  end
end
