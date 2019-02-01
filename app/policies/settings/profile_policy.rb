# frozen_string_literal: true

class Settings::ProfilePolicy < ApplicationPolicy
  def edit?
    account && !account.guest?
  end
end
