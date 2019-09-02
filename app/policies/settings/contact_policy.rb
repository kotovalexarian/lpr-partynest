# frozen_string_literal: true

class Settings::ContactPolicy < ApplicationPolicy
  def index?
    !!account
  end
end
