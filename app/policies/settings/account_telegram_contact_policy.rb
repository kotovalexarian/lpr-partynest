# frozen_string_literal: true

class Settings::AccountTelegramContactPolicy < ApplicationPolicy
  def index?
    !!context.guest_account
  end

  class Scope < Scope
    def resolve
      return scope.none if context.guest_account.nil?

      scope.where(account: context.guest_account)
    end
  end
end
