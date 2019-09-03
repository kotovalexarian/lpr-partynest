# frozen_string_literal: true

class Settings::AppearancePolicy < ApplicationPolicy
  def update?
    !!account
  end

  def permitted_attributes_for_update
    %i[timezone]
  end
end
