# frozen_string_literal: true

class MembershipPoolPolicy < ApplicationPolicy
  def show?
    return false if context.account.nil?

    context.account&.is_superuser? ||
      record.accounts.include?(context.account)
  end

  class Scope < Scope
    def resolve
      return scope.none if context.account.nil?
      return scope.all  if context.account.is_superuser?

      associated
    end

  private

    def associated
      scope.includes(:membership_pool_accounts)
           .where(membership_pool_accounts: { account: context.account })
    end
  end
end
