# frozen_string_literal: true

class Settings::AppearancePolicy < ApplicationPolicy
  def update?
    !!account
  end
end
