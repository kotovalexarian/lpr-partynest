# frozen_string_literal: true

class Settings::SessionPolicy < ApplicationPolicy
  def index?
    !!account
  end
end
