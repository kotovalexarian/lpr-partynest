# frozen_string_literal: true

class PassportPolicy < ApplicationPolicy
  def show?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
