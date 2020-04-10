# frozen_string_literal: true

class Settings::PassportPolicy < ApplicationPolicy
  def index?
    account&.person
  end
end
