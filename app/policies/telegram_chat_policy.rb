# frozen_string_literal: true

class TelegramChatPolicy < ApplicationPolicy
  def index?
    context.account&.is_superuser?
  end

  def show?
    context.account&.is_superuser?
  end

  class Scope < Scope
    def resolve
      return scope.all if context.account&.is_superuser?

      scope.none
    end
  end
end
