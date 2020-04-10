# frozen_string_literal: true

class Settings::PassportPolicy < ApplicationPolicy
  def index?
    account&.person
  end

  def show?
    account&.person && record.person == account.person
  end
end
