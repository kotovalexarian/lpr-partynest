# frozen_string_literal: true

class Settings::PersonPolicy < ApplicationPolicy
  def show?
    !!account
  end
end
