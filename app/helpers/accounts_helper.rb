# frozen_string_literal: true

module AccountsHelper
  def account_link_or_none(account)
    if account.nil?
      none
    elsif policy(account).show?
      link_to account.nickname, account
    else
      account.nickname
    end
  end

  def staff_account_link_or_none(account)
    if account.nil?
      none
    elsif policy([:staff, account]).show?
      link_to account.nickname, [:staff, account]
    elsif policy(account).show?
      link_to account.nickname, account
    else
      account.nickname
    end
  end
end
