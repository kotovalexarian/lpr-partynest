# frozen_string_literal: true

class Settings::AccountTelegramContactPolicy < ApplicationPolicy
  def index?
    account && !account.guest?
  end

  class Scope < Scope
    def resolve
      return scope.none if account.nil? || account.guest?

      scope.where(account: account)
    end
  end
end
