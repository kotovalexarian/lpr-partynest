# frozen_string_literal: true

class AsymmetricKeyPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
