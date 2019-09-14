# frozen_string_literal: true

class AsymmetricKeyPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
