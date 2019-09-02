# frozen_string_literal: true

class Settings::PersonPolicy < ApplicationPolicy
  def show?
    !!account
  end

  def create?
    return false if account.nil?

    return false unless account.person.nil?
    return false unless record.account.nil?

    return false if record.account_connection_token.blank?

    true
  end
end
